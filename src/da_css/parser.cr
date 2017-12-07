

module DA_CSS

  class Parser

    alias PARENT_NODE = Nil | Node::Selector_With_Body | Node::Property | Node::Assignment | Node::Function_Call

    protected getter origin : Parser | Nil = nil

    getter reader      : Char::Reader
    getter parent      : Parser | Nil = nil
    getter parent_node : PARENT_NODE = nil
    getter parent_count = 0
    getter doc          = Doc.new
    getter index        = 0

    @is_done                    = false
    @stop_on_char : Char | Nil = nil
    @caches                     = Chars::Array.new
    @cache                      = Chars.new

    def initialize(@parent, @parent_node, @doc, @stop_on_char)
      @parent_count = parent.parent_count + 1
      @reader       = parent.reader
      @origin       = parent.origin || parent
    end # === def initialize

    def initialize(@parent, @parent_node, @doc)
      @parent_count = parent.parent_count + 1
      @reader       = parent.reader
      @origin       = parent.origin || parent
    end # === def initialize

    def initialize(raw : String)
      @reader = Char::Reader.new(raw)
    end # === def initialize

    def parse
      raise Error.new("Already parsed.") if done?

      stop_on_char = @stop_on_char
      stop_on_char_found = false
      while current? && !done?
        stop_on_char_found = true if stop_on_char && stop_on_char == current
        parse(next_char)
        break if stop_on_char_found
      end

      if stop_on_char && !stop_on_char_found
        raise Error.new("Missing char: #{stop_on_char.inspect}")
      end

      if !@cache.empty?
        raise Error.new("Invalid chars: #{@cache.to_s.inspect}")
      end

      if !@caches.empty?
        raise Error.new("Invalid chars: #{@caches.join.to_s.inspect}")
      end

      return doc
    end # === def parse

    def parse(c : Char)
      case

      when c.whitespace?
        save_cache

      # PARSE: comment
      when c == '/' && current == '*'
        if !@cache.empty?
          raise Error.new("You can't put a comment while defining something else.")
        end

        next_char # asterisk
        comment = Chars.new
        was_closed = false
        loop do
          grab_chars(comment, '/')
          break if !current?

          if @cache.prev(2) == '*'
            comment.pop
            was_closed = true
            break
          end
        end # loop

        if was_closed
          doc.push(Node::Comment.new(comment))
        else
          raise Error.new("Comment was not closed.")
        end

      # PARSE: string '
      # PARSE: string "
      when c == '\'' || c == '"'
        if !@cache.empty?
          raise Node::Invalid_Text.new("Can't start a quoted string here.")
        end
        doc.push Node::Text.new(grab_chars(Chars.new, c))

      when c == '{'
        save_cache
        raise Error.new("Block must have a selector.") if @caches.empty?
        doc.push Node::Selector_With_Body.new(grab_caches, self)

      when c == '}'
        if @parent_count == 0
          if next?
            raise Error.new("Missing opening {")
          end
        else
          done!
        end

      when c == ':'
        save_cache
        doc.push Node::Property.new(grab_caches.join, self)

      when c == ';'
        save_cache
        parse_caches unless @caches.empty?

      when c == '='
        save_cache
        doc.push Node::Assignment.new(grab_caches.join, self)

      when c == '('
        save_cache
        doc.push Node::Function_Call.new(grab_caches.join, self)

      when c == ')'
        done!

      when c.whitespace?
        save_cache

      else
        @cache.push c

      end # === while
    end # === def parse


    def origin?
      @origin.is_a?(Parser)
    end

    def parent?
      @parent.is_a?(Parser)
    end

    def origin
      @origin
    end

    def done?
      return true if @is_done || !next?

      p = @parent
      return true if p.is_a?(Parser) && p.done?
      false
    end

    def done!
      @is_done = true
      self
    end

    def current?
      (@reader.current_char) ? true : false
    end

    def current?(c : Char)
      current? && current == c
    end # === def current?

    def current
      @reader.current_char
    end

    def next?
      @reader.has_next?
    end

    def peek
      return nil unless @reader.has_next?
      @reader.peek_next_char
    end

    def skip_to(c : Char)
      if current? && !current.whitespace?
        next_char = next? && peek
        if next_char && next_char.whitespace?
          next_char
        end
      end

      while (curr = current) && curr && curr.whitespace?
        next_char
      end

      return self if current == c
      raise Error.new("Not found: #{c.inspect}")
    end # === def skip_to

    def next_char
      @reader.next_char
    end

    def grab_chars(c : Char)
      grab_chars(Chars.new, c)
    end # === def grab_chars

    def grab_chars(dest : Chars, c : Char)
      grab_chars(c) { |x|
        dest.push x
      }
      dest
    end # === def grab_chars

    # Example: "a b c;" -> grab_chars(';')
    # Note: ';' here will be grabbed, but not yield-ed
    #   to the block.
    def grab_chars(c : Char)
      while current?
        case current
        when c
          next_char
          return self
        else
          yield next_char
        end
      end
    end # === def grab_chars

    def grab_between(open : Char, close : Char)
      if current != open
        raise Error.new(":grab_between: Not on a #{open.inspect} char.")
      end

      next_char
      count = 1
      chars = Chars.new
      while current? && count > 0
        case current
        when open
          count += 1
          next_char
        when close
          count -= 1
          next_char
        else
          chars.push next_char
        end
      end # === while

      if count > 0
        raise Error.new("Missing closing chars: '#{close}'")
      end
      if count < 0
        raise Error.new("Missing open chars: '#{open}'")
      end

      return chars
    end # === def grab_between

    def save_cache
      return false if @cache.empty?
      raise Error.new("CHAR cache is empty. Can't save.") if @cache.empty?
      cache = grab_cache
      @caches.push cache
      cache
    end # === def save_cache

    def grab_cache
      raise Error.new("CHAR cache is empty. Can't grab.") if @cache.empty?
      cache = @cache.freeze!
      @cache = Chars.new
      cache
    end # === def grab_cache

    def grab_caches
      raise Error.new("No saved cache. Can't grab caches.") if @caches.empty?
      arr = @caches
      @caches = Chars::Array.new
      return arr
    end # === def grab_unknowns

    def parse_caches
      grab_caches.each { |c|
        doc.push Node.from_chars(c.freeze!)
      }
    end # === def parse_caches

  end # === class Parser

end # === module DA_CSS
