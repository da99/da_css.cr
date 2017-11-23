
require "./exception"
require "./codepoints"
require "./codepoints.array"
require "./node"
require "./node.unknown"
require "./node.empty_array"
require "./node.assignment"
require "./node.selector"
require "./node.selector_with_body"
require "./node.comment"
require "./node.color"
require "./node.slash"
require "./node.text"
require "./node.number"
require "./node.unit"
require "./node.function_call"
require "./node.number_unit"
require "./node.percentage"
require "./node.keyword"
require "./node.property"
require "./node.statement"
require "./doc"
require "./parser"
require "./io_css"
require "./printer"

module DA_CSS

  class Parser

    getter codepoints : Codepoints
    protected getter origin : Parser | Nil = nil
    getter parent : Parser | Nil = nil
    getter parent_count = 0
    getter doc = Doc.new

    @is_done                  = false
    @final_char : Int32 | Nil = nil
    @caches                   = Codepoints::Array.new
    @cache                    = Codepoints.new
    getter index = 0
    getter size = 0

    def initialize(@parent, @final_char)
      @parent_count = parent.parent_count + 1
      @codepoints   = parent.codepoints
      @origin       = parent.origin || parent
    end # === def initialize

    def initialize(@parent)
      @parent_count = parent.parent_count + 1
      @codepoints   = parent.codepoints
      @origin       = parent.origin || parent
    end # === def initialize

    def initialize(raw : String)
      @codepoints = Codepoints.new(raw)
      @size = @codepoints.size
    end # === def initialize

    def parse
      raise Exception.new("Already parsed.") if done?

      last_chr = false
      while current? && !done?
        last_chr = true if @final_char && @final_char == current
        parse(grab)
        break if last_chr
      end

      fin_chr = @final_char
      if fin_chr && !last_chr
        raise Exception.new("Missing char: #{fin_chr.chr}")
      end

      if !@cache.empty?
        raise Exception.new("Invalid characters: #{@cache.to_s.inspect}")
      end

      if !@caches.empty?
        raise Exception.new("Invalid characters: #{@caches.join.to_s.inspect}")
      end

      return doc
    end # === def parse

    def parse(i : Int32)
      case

      when Codepoints.whitespace?(i)
        if !@cache.empty?
          save_cache
        end

      # PARSE: comment
      when i == ('/').hash && current == ('*').hash
        if !@cache.empty?
          raise Exception.new("You can't put a comment while defining something else.")
        end

        grab # asterisk
        comment = Codepoints.new
        was_closed = false
        loop do
          grab_slice(comment, '/'.hash)
          break if !current?

          if prev(2).chr == '*'
            comment.pop
            was_closed = true
            break
          end
        end # loop

        if was_closed
          doc.push(Node::Comment.new(comment))
        else
          raise Exception.new("Comment was not closed.")
        end

      # PARSE: string '
      # PARSE: string "
      when i == ('\'').hash || i == ('"').hash
        if !@cache.empty?
          raise Node::Invalid_Text.new("Can't start a quoted string here.")
        end
        doc.push Node::Text.new(grab_slice(Codepoints.new, i))

      when i == ('{').hash
        save_cache
        raise Exception.new("Block must have a selector.") if @caches.empty?
        body = Parser.new(self).parse
        doc.push Node::Selector_With_Body.new(grab_caches, body)

      when i == '}'.hash
        if @parent_count == 0
          if next?
            raise Exception.new("Missing opening {")
          end
        else
          done!
        end

      when i == ':'.hash
        save_cache
        raise Exception.new("Property being defined with a key") if @caches.empty?
        key = grab_caches.join
        value = Parser.new(self, ';'.hash).parse
        doc.push Node::Property.new(key, value)

      when i == ';'.hash
        save_cache
        parse_caches unless @caches.empty?

      when i == '='.hash
        save_cache
        raise Exception.new("'=' not allowed here.") unless @caches.size == 1
        var_name = grab_caches.join

        value = Parser.new(self, ';'.hash).parse
        doc.push Node::Assignment.new(var_name, value)

      when i == '('.hash
        save_cache
        key  = grab_caches.join
        args = Parser.new(self, ')'.hash).parse
        doc.push Node::Function_Call.new(key, args)

      when i == ')'.hash
        done!

      when Codepoints.whitespace?(i)
        save_cache

      else
        @cache.push i

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
      o = origin
      if o
        o.index < o.size
      else
        @index < @size
      end
    end

    def current?(i : Int32)
      current? && current == i
    end # === def current?

    def current
      o = origin
      if o
        o.current
      else
        @codepoints[@index]
      end
    end

    def prev(i : Int32 = 1)
      o = origin
      if o
        o.prev(i)
      else
        @codepoints[@index - i]
      end
    end

    def next?
      o = origin
      if o
        o.next?
      else
        @index < (@size - 2)
      end
    end

    def peek
      o = origin
      return o.peek if o
      @codepoints[@index + 1]
    end

    def put_back
      o = origin
      return o.put_back if o

      @index -= 1
      self
    end # === def put_back

    def grab
      o = origin
      return o.grab if o
      v = current
      @index += 1
      v
    end

    def skip_to(i : Int32)
      if current? && !whitespace?(current) && next? && whitespace?(peek)
        grab
      end

      while current? && whitespace?(current)
        grab
      end

      return self if current? && current == i
      raise Exception.new("Not found: #{i.chr}")
    end # === def skip_to

    def grab_slice(i : Int32)
      grab_slice(Codepoints.new, i)
    end # === def grab_slice

    def grab_slice(dest : Codepoints, i : Int32)
      grab_slice(i) { |x|
        dest.push x
      }
      dest
    end # === def grab_slice

    # Example: "a b c;" -> grab_slice(';'.hash)
    # Note: ';' here will be grabbed, but not yield-ed
    #   to the block.
    def grab_slice(i : Int32)
      while current?
        case current
        when i
          grab
          return self
        else
          yield grab
        end
      end
    end # === def grab_slice

    def grab_between(open : Int32, close : Int32)
      if current != open
        raise Exception.new(":grab_between: Not on a '#{open.chr}' char.")
      end

      grab
      count = 1
      codes = Codepoints.new
      while current? && count > 0
        case current
        when open
          count += 1
          grab
        when close
          count -= 1
          grab
        else
          codes.push grab
        end
      end # === while

      if count > 0
        raise Exception.new("Missing closing chars: '#{close.chr}'")
      end
      if count < 0
        raise Exception.new("Missing open chars: '#{open.chr}'")
      end

      return codes
    end # === def grab_between

    def save_cache
      return false if @cache.empty?
      raise Exception.new("CHAR cache is empty. Can't save.") if @cache.empty?
      c = grab_cache
      @caches.push c
      c
    end # === def save_cache

    def grab_cache
      raise Exception.new("CHAR cache is empty. Can't grab.") if @cache.empty?
      c = @cache
      @cache = Codepoints.new
      c
    end # === def grab_cache

    def grab_caches
      raise Exception.new("No saved cache. Can't grab caches.") if @caches.empty?
      arr = @caches
      @caches = Codepoints::Array.new
      return arr
    end # === def grab_unknowns

    def parse_caches
      grab_caches.each { |c|
        doc.push Node.from_codepoints(c)
      }
    end # === def parse_caches

  end # === class Parser

end # === module DA_CSS
