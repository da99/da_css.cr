

module DA_CSS

  # Right now the "Parser" is a combined lexer and parser.
  class Parser

    alias ROOT_NODE_TYPES = Node::Media_Query | Node::Selector_With_Body

    alias OPEN_NODE_TYPES =
      Node::Media_Query |
      Node::Selector_With_Body |
      Node::Property |
      Node::Function_Call |
      Node::Media_Query_Conditions |
      Node::Media_Query_Condition

    getter origin : Origin
    getter nodes = Deque(Node::Media_Query | Node::Selector_With_Body).new
    @done = false

    delegate line_num, current_char?, current_char, next_char?, next_char, string, to: @origin

    @open_nodes = Deque(OPEN_NODE_TYPES).new

    def initialize(@origin)
    end # === def initialize

    private def cache
      @cache ||= A_Char_Deque.new(self)
      @cache.not_nil!
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

      @nodes
    end # === def parse

    def goto!(target : Char)
      was_found = false
      while next_char?
        c = current_char
        next_char
        case
        when c == target
          was_found = true
          break
        else
          cache.push c
        end
      end # === while

      if !was_found
        raise Error.new("Missing character: #{target.inspect}")
      end

      return was_found
    end # === def goto

    def parse(c : Char)
      case

      when c == '@' && cache.empty? && root?
        goto!('{')
        new_node = Node::Media_Query.new(consume_cache)
        open_node(new_node)

      when c == ')' && open?(Node::Property)
        save_cache unless cache.empty?
        nodes = caches_to_nodes
        l = close_node(Node::Property)
        case l
        when Node::Property
          nodes.each { |n|
            l.push n
          }
        end

      when c == '{' && open?(Node::Media_Query) && cache.empty?

      when c == '}' && open?(Node::Media_Query) && cache.empty?
        close_node(Node::Media_Query)

      when c == ',' && open?(Node::Media_Query_Condition)
        save_cache unless cache.empty?
        cond = current_node(Node::Media_Query_Condition)
        if cond.is_a?(Node::Media_Query_Condition)
          cache.split.each { |c|
            v = case
                when Node::Number_Unit.looks_like?(c)
                  Node::Number_Unit.new(c)
                when Node::Number.looks_like?(c)
                  Node::Number.new(c)
                when Node::Percentage.looks_like?(c)
                  Node::Percentage.new(c)
                else
                  Node::Keyword.new(c)
                end
            cond.push(v)
          }
        end
        close_node(Node::Media_Query_Condition)

      when c == ',' && open?(Node::Property)
        save_cache unless cache.empty?
        q = caches_to_nodes
        l = close_node(Node::Property)
        case l
        when Node::Property
          q.each { |n| l.push n }
        end

      when c.whitespace?
        save_cache unless cache.empty?

      # PARSE: comment
      when c == '/' && origin.current_char == '*'
        origin.next_char # == skip asterisk
        was_closed = false
        comment = A_Char_Deque.new(self)
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
        n = current_node
        case n
        when Node::Function_Call
          n.push Node::Text.new(consume_chars(A_Char_Deque.new(self), c))
        end

      when c == '{' && !cache.empty? && root?
        save_cache unless cache.empty?
        new_node = Node::Selector_With_Body.new(consume_cache)
        open_node(new_node)

      when c == '{' && !cache.empty? && open?(Node::Media_Query)
        save_cache unless cache.empty?
        new_node = Node::Selector_With_Body.new(consume_cache)
        t = current_node(Node::Media_Query)
        if t.is_a?(Node::Media_Query)
          t.push new_node
        end
        open_node(new_node)

      when c == '}' && open?(Node::Selector_With_Body)
        close_node(Node::Selector_With_Body)

      when c == ':' && !cache.empty? && open?(Node::Media_Query_Conditions)
        new_node = Node::Media_Query_Condition.new(consume_cache)
        mqc = current_node(Node::Media_Query_Conditions)
        mqc.push(new_node) if mqc.is_a?(Node::Media_Query_Conditions)
        open_node(new_node)

      when c == ':' && !cache.empty? && open?(Node::Selector_With_Body)
        save_cache unless cache.empty?
        new_node = Node::Property.new(consume_cache)
        l = current_node(Node::Selector_With_Body)
        if l.is_a?(Node::Selector_With_Body)
          l.push new_node
        end
        open_node new_node

      when c == ';' && !cache.empty? && open?(Node::Property)
        save_cache unless cache.empty?
        nodes = caches_to_nodes
        l = close_node(Node::Property)
        case l
        when Node::Property
          nodes.each { |n|
            l.push n
          }
        end

      when c == '(' && open?(Node::Media_Query)
        save_cache unless cache.empty?
        mq = current_node(Node::Media_Query)
        if mq.is_a?(Node::Media_Query)
          consume_cache.split.each { |c|
            mq.push Node::Media_Query_Keyword.new(c)
          }
        end
        new_node = Node::Media_Query_Conditions.new
        open_node( new_node )

      when c == ')' && open?(Node::Media_Query_Condition)
        save_cache unless cache.empty?
        cond = close_node(Node::Media_Query_Condition)
        mqc = close_node(Node::Media_Query_Conditions)
        if cond.is_a?(Node::Media_Query_Condition) && mqc.is_a?(Node::Media_Query_Conditions)
          consume_cache.split.each { |c|
            v = case
                when Node::Number_Unit.looks_like?(c)
                  Node::Number_Unit.new(c)
                when Node::Number.looks_like?(c)
                  Node::Number.new(c)
                when Node::Percentage.looks_like?(c)
                  Node::Percentage.new(c)
                else
                  Node::Keyword.new(c)
                end
            cond.push(v)
          }
          mq = current_node(Node::Media_Query)
          if mq.is_a?(Node::Media_Query)
            mq.push mqc
          end
        end

      when c == ')' && open?(Node::Media_Query_Conditions)
        save_cache if !cache.empty?
        mqc = close_node(Node::Media_Query_Conditions)
        case mqc
        when Node::Media_Query_Conditions
          consume_cache.split.each { |c|
            mqc.push Node::Media_Query_Keyword.new(c)
          }
          mq = current_node(Node::Media_Query)
          if mq.is_a?(Node::Media_Query)
            mq.push mqc
          end
        end # case mqc

      when c == '(' && !cache.empty? && open?(Node::Property)
        save_cache unless cache.empty?
        new_node = Node::Function_Call.new(consume_cache)
        l = current_node(Node::Property)
        case l
        when Node::Property
          l.push new_node
        end
        open_node(new_node)

      when c == ')' && open?(Node::Function_Call)
        save_cache if !cache.empty?
        f = close_node(Node::Function_Call)

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

    def root?
      @open_nodes.empty?
    end # === def root?

    def open?(klass)
      @open_nodes.last?.class == klass
    end

    def open_node(x)
      case x
      when ROOT_NODE_TYPES
        @nodes.push x
      end
      @open_nodes.push x
    end # === def open_node

    def current_node
      l = @open_nodes.last?
    end

    def current_node(x)
      l = @open_nodes.last?
      if l.class != x
        raise Error.new("Node was not opened: #{x.to_s}")
      end
      l
    end

    def close_node(klass)
      n = @open_nodes.last?
      if n.class != klass
        raise Error.new("Not properly closed: #{n.class}")
      end
      @open_nodes.pop
    end # === def close

    def consume_chars(c : Char)
      consume_chars(Char_Deque.new(self), c)
    end # === def consume_chars

    def consume_chars(dest : A_Char_Deque, c : Char)
      consume_chars(c) { |x|
        dest.push x
      }
      dest
    end # === def consume_chars

    # Example: "a b c;" -> consume_chars(';')
    # Note: ';' here will be consume-ed, but not yield-ed
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
      chars = A_Char_Deque.new(self)
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
      cache.push SPACE
      cache
    end # === def save_cache

    def consume_cache
      raise Exception.new("Cache is empty. Line: #{origin.line_num+1}") if cache.empty?
      c = cache.freeze!
      @cache = A_Char_Deque.new(self)
      c
    end # === def consume_cache

    def caches_to_nodes
      q = Deque(Node::VALUE_TYPES | Node::Unknown).new
      consume_cache.split.each { |c|
        q.push Node.from_chars(c.freeze!)
      }
      q
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
