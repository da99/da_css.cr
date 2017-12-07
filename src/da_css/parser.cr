

module DA_CSS

  class Parser

    alias NODE_TYPES_AS_PARENTS =
      Node::Selector_With_Body | Node::Property |
      Node::Assignment | Node::Function_Call
    alias PARENT_TYPES =
      Nil | Parser | NODE_TYPES_AS_PARENTS

    alias NODE_TYPES =
      Node::Text | Node::Assignment |
      Node::Selector_With_Body | Node::Comment |
      Node::Property | Node::Function_Call | Node::Color |
      Node::Keyword | Node::Property | Node::Number | Node::Number_Unit |
      Node::Percentage | Node::Slash | Node::Unknown

    property parent : PARENT_TYPES = nil

    getter nodes = Deque(NODE_TYPES).new

    @reader : Parser | Char::Reader = Char::Reader.new("")

    @is_done = false

    getter pos_line = 0

    def initialize
    end # === def initialize

    def initialize(raw : String)
      @reader = Char::Reader.new(raw)
    end # === def initialize

    def parent=(parent : NODE_TYPES_AS_PARENTS)
      @parent   = parent
      @reader   = parent.parent
      @pos_line = parent.parent.pos_line
      @parent
    end # === def initialize

    private def cache
      @cache ||= Chars.new(self)
      @cache.not_nil!
    end

    private def caches
      @caches ||= Chars::Group.new(self)
      @caches.not_nil!
    end

    def parse
      raise Error.new("Already parsed.") if done?

      while current_char? && !done?
        c = current_char
        next_char unless done?
        parse(c)
      end

      if !cache.empty?
        raise Error.new("Invalid chars: #{cache.to_s.inspect}", cache)
      end

      if !caches.empty?
        raise Error.new("Invalid chars: #{caches.join.to_s.inspect}", caches.first)
      end

      self
    end # === def parse

    def parse(c : Char)
      case

      when c.whitespace?
        if c == '\n'
          @pos_line += 1
        end
        grab_non_empty_cache_to_group

      # PARSE: comment
      when c == '/' && current_char == '*'
        next_char # == skip asterisk
        was_closed = false
        comment = Chars.new(self)
        loop do
          grab_chars(comment, '/')
          break if !current_char?

          if cache.prev(2) == '*'
            comment.pop
            was_closed = true
            break
          end
        end # loop

        if was_closed
          raise Error.new("Comment was not closed: #{comment.pos_summary_in_english}")
        end

      # PARSE: string '
      # PARSE: string "
      when c == '\'' || c == '"'
        if !cache.empty?
          raise Node::Invalid_Text.new("Can't start a quoted string here.")
        end
        @nodes.push Node::Text.new(grab_chars(Chars.new(self), c))

      when c == '{'
        grab_non_empty_cache_to_group
        @nodes.push Node::Selector_With_Body.new(grab_caches, self)

      when c == '}'
        done!

      when c == ':'
        grab_non_empty_cache_to_group
        @nodes.push Node::Property.new(grab_caches.join, self)

      when c == ';'
        grab_non_empty_cache_to_group
        caches_to_nodes
        done!

      when c == '='
        grab_non_empty_cache_to_group
        @nodes.push Node::Assignment.new(grab_caches.join, self)

      when c == '('
        grab_non_empty_cache_to_group
        @nodes.push Node::Function_Call.new(grab_caches.join, self)

      when c == ')'
        grab_non_empty_cache_to_group
        caches_to_nodes
        done!

      when c.whitespace?
        grab_non_empty_cache_to_group

      else
        cache.push c

      end # === while
    end # === def parse

    def parent?
      @parent.is_a?(Parser)
    end

    def done?
      return true if @is_done || !has_next?

      p = @parent
      return true if p.is_a?(Parser) && p.done?
      false
    end

    def done!
      @is_done = true
      self
    end

    {% for x in %w(pos current_char next_char has_next? peek_next_char) %}
      def {{x.id}}(*args)
        @reader.{{x.id}}(*args)
      end
    {% end %}

    def current_char?
      (current_char) ? true : false
    end

    def current_char?(c : Char)
      current_char == c
    end # === def current_char?

    def skip_to(c : Char)
      if current_char? && !current_char.whitespace?
        next_char = next? && peek
        if next_char && next_char.whitespace?
          next_char
        end
      end

      while (curr = current_char) && curr && curr.whitespace?
        next_char
      end

      return self if current_char == c
      raise Error.new("Not found: #{c.inspect}")
    end # === def skip_to

    def grab_chars(c : Char)
      grab_chars(Chars.new(self), c)
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
      while current_char?
        case current_char
        when c
          next_char
          return self
        else
          yield next_char
        end
      end
    end # === def grab_chars

    def grab_between(open : Char, close : Char)
      if current_char != open
        raise Error.new(":grab_between: Not on a #{open.inspect} char.")
      end

      next_char
      count = 1
      chars = Chars.new(self)
      while current_char? && count > 0
        case current_char
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

    def grab_non_empty_cache_to_group
      return false if cache.empty?
      cache = grab_cache
      caches.push cache
      cache
    end # === def grab_non_empty_cache_to_group

    def grab_cache
      c = cache.freeze!
      @cache = Chars.new(self)
      c
    end # === def grab_cache

    def grab_caches
      arr = caches
      @caches = Chars::Group.new(self)
      return arr
    end # === def grab_unknowns

    def caches_to_nodes
      grab_caches.each { |c|
        next if c.empty?
        @nodes.push Node.from_chars(c.freeze!)
      }
    end # === def caches_to_nodes

    def inspect(io)
      io << "Parser["
      @nodes.each_with_index { |x, i|
        io << ", " unless i == 0
        io << x.class.to_s << "(instance)"
      }
      io << "]"
    end # === def inspect

    def print(printer : Printer)
      @nodes.each_with_index { |x, i|
        printer.raw! " " if i != 0
        x.print(printer)
      }
      self
    end # === def print

    def to_s
      io = IO::Memory.new
      @nodes.each_with_index { |x, i|
        io << ' ' if i != 0
        io << x.to_s
      }
      io.to_s
    end # === def to_s

    def first_and_only(err_msg)
      return first if @nodes.size == 1
      raise Error.new(err_msg)
    end # === def first_and_only

    def nodes?
      !@nodes.empty?
    end # === def empty?

  end # === class Parser

end # === module DA_CSS
