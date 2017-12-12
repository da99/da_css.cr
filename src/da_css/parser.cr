

module DA_CSS

  class Parser

    alias OPEN_NODE_TYPES =
      Node::Media_Query |
      Node::Selector_With_Body |
      Node::Property | Node::Function_Call

    getter origin : Origin
    getter nodes = Deque(Node::Media_Query | Node::Selector_With_Body).new
    @done = false

    delegate line_num, current_char?, current_char, next_char, string, to: @origin

    @open_nodes = Deque(OPEN_NODE_TYPES).new

    def initialize(@origin)
    end # === def initialize

    private def cache
      @cache ||= Char_Deque.new(self)
      @cache.not_nil!
    end

    private def caches
      @caches ||= Char_Deque_Deque.new(self)
      @caches.not_nil!
    end

    def parse
      raise Error.new("Already parsed.") if done?

      while origin.current_char? && !done?
        c = origin.current_char
        origin.next_char
        parse(c)
      end

      if !cache.empty?
        raise Error.new("Unknown value: ", cache.pos_summary(cache.to_s))
      end

      if !caches.empty?
        raise Error.new("Unknown values: ", caches.first.pos_summary(caches.join.to_s))
      end

      @nodes
    end # === def parse

    def parse(c : Char)
      case

      when c == '@' && nothing_cached? && root?
        while current_char? && !current_char.whitespace?
          cache.push current_char
          next_char
        end
        new_node = Node::Media_Query.new(consume_cache)
        open_in_root(new_node)

      when c == '(' && nothing_cached? && open?(Node::Media_Query)

      when c == ')' && open?(Node::Property)
        save_cache unless cache.empty?
        caches_to_nodes
        close(Node::Property)

      when c == '{' && open?(Node::Media_Query) && nothing_cached?

      when c == '}' && open?(Node::Media_Query) && nothing_cached?
        close(Node::Media_Query)

      when c == ',' && open?(Node::Property)
        save_cache unless cache.empty?
        caches_to_nodes
        close(Node::Property)

      when c.whitespace?
        save_cache unless cache.empty?

      # PARSE: comment
      when c == '/' && origin.current_char == '*'
        origin.next_char # == skip asterisk
        was_closed = false
        comment = Char_Deque.new(self)
        loop do
          consume_chars(comment, '/')
          break if !current_char?

          if comment.prev(2) == '*'
            comment.pop(2)
            was_closed = true
            break
          end
        end # loop

        if !was_closed
          raise Error.new("Comment was not closed: #{comment.pos_summary}")
        end

      # PARSE: string '
      # PARSE: string "
      when (c == '\'' || c == '"') && open?(Node::Function_Call)
        if !cache.empty?
          raise Node::Invalid_Text.new("Can't start a quoted string here.")
        end
        n = @open_nodes.last
        case n
        when Node::Function_Call
          n.push Node::Text.new(consume_chars(Char_Deque.new(self), c))
        end

      when c == '{' && something_cached? && root?
        save_cache unless cache.empty?
        new_node = Node::Selector_With_Body.new(consume_saved_caches)
        open_in_root(new_node)

      when c == '{' && something_cached? && open?(Node::Media_Query)
        save_cache unless cache.empty?
        new_node = Node::Selector_With_Body.new(consume_saved_caches)
        t = @open_nodes.last?
        case t
        when Node::Media_Query
          t.push new_node
        end
        @open_nodes.push new_node

      when c == '}' && open?(Node::Selector_With_Body)
        close(Node::Selector_With_Body)

      when c == ':' && something_cached? && (open?(Node::Media_Query) || open?(Node::Selector_With_Body))
        save_cache unless cache.empty?
        new_node = Node::Property.new(consume_saved_caches.join)
        l = @open_nodes.last?
        case l
        when Node::Media_Query, Node::Selector_With_Body
          l.push new_node
        end
        @open_nodes.push new_node

      when c == ';' && something_cached? && open?(Node::Property)
        save_cache unless cache.empty?
        caches_to_nodes
        close(Node::Property)

      when c == '(' && something_cached? && open?(Node::Property)
        save_cache unless cache.empty?
        new_node = Node::Function_Call.new(consume_saved_caches.join)
        l = @open_nodes.last?
        case l
        when Node::Property
          l.push new_node
        end
        @open_nodes.push(new_node)

      when c == ')' && open?(Node::Function_Call)
        save_cache unless cache.empty?
        caches_to_nodes
        close(Node::Function_Call)

      when c == '}' || c == ';' || c == ')'
        raise Error.new("Danglering char: #{c} (line: #{origin.line_num+1})")

      when c.whitespace?
        save_cache unless cache.empty?

      else
        cache.push c

      end # === while
    end # === def parse

    def done?
      @done || origin.done?
    end

    def something_cached?
      !nothing_cached?
    end # === def something_cached?

    def nothing_cached?
      cache.empty? && caches.empty?
    end # === def nothing_cached?

    def root?
      @open_nodes.empty?
    end # === def root?

    def open?(klass)
      @open_nodes.last?.class == klass
    end

    def open_in_root(x : Node::Media_Query | Node::Selector_With_Body)
      @open_nodes.push x
      @nodes.push x
    end # === def open_in_root

    def close(klass)
      n = @open_nodes.last?
      if n.class != klass
        raise Error.new("Not properly closed: #{n.class}")
      end
      @open_nodes.pop
    end # === def close

    def consume_chars(c : Char)
      consume_chars(Char_Deque.new(self), c)
    end # === def consume_chars

    def consume_chars(dest : Char_Deque, c : Char)
      consume_chars(c) { |x|
        dest.push x
      }
      dest
    end # === def consume_chars

    # Example: "a b c;" -> consume_chars(';')
    # Note: ';' here will be consumebed, but not yield-ed
    #   to the block.
    def consume_chars(c : Char)
      while current_char?
        if current_char == c
          next_char
          return self
        else
          yield next_char
        end
      end
    end # === def consume_chars

    def consume_between(open : Char, close : Char)
      if current_char != open
        raise Error.new(":consume_between: Not on a #{open.inspect} char.")
      end

      next_char
      count = 1
      chars = Char_Deque.new(self)
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
    end # === def consume_between

    def save_cache
      if cache.empty?
        raise Error.new("Missing chars in: line #{origin.line_num + 1}")
      end
      cache = consume_cache
      caches.push cache
      cache
    end # === def save_cache

    def consume_cache
      raise Exception.new("Cache is empty. Line: #{origin.line_num+1}") if cache.empty?
      c = cache.freeze!
      @cache = Char_Deque.new(self)
      c
    end # === def consume_cache

    def consume_saved_caches
      raise Exception.new("Caches are empty. Line: #{origin.line_num+1}") if caches.empty?
      group = caches
      @caches = Char_Deque_Deque.new(self)
      return group
    end # === def consume_unknowns

    def caches_to_nodes
      consume_saved_caches.each { |c|
        container = @open_nodes.last
        case container
        when Node::Property
          container.push Node.from_chars(c.freeze!)
        else
          raise Error.new("Node can't contain other nodes: #{container.class}")
        end
      }
    end # === def caches_to_nodes

    def done!
      @done = true
      self
    end

    def nodes?
      !@nodes.empty?
    end # === def empty?

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

  end # === class Parser

end # === module DA_CSS
