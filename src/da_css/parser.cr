


module DA_CSS

  # Right now the "Parser" is a combined lexer and parser.
  class Parser

    def self.parse(origin)
      new(origin).parse
    end

    alias ROOT_NODE_TYPES = Raw_Media_Query | Raw_Blok
    alias OPEN_NODE_TYPES = ROOT_NODE_TYPES

    getter origin : String
    getter nodes = Deque(ROOT_NODE_TYPES).new

    @token      = Token.new
    @tokens     = Deque(Token).new
    @open_nodes = Deque(OPEN_NODE_TYPES).new

    # A Char::Reader is used because it adds
    # protection against invalid codepoints.
    @reader : Char::Reader
    delegate current_char?, current_char, next_char, next_char?, to: @reader

    def initialize(@origin)
      @reader = Char::Reader.new(@origin)
    end # === def initialize

    def parse
      while !done?
        p = current_position
        c = current_char
        next_char

        case
        when c == '@' && !stack? && !tokens? && root?
          upto('{'); next_char
          save_token if stack?
          open_node(Raw_Media_Query.new(consume_tokens))

        when c == '}' && open_node?(Raw_Media_Query) && !stack? && !tokens?
          close_node(Raw_Media_Query)

        # PARSE: comment
        when c == '/' && current_char == '*' && !stack? && !tokens?
          next_char # == skip asterisk
          was_closed = false
          comment    = Token.new
          while !done?
            through('*')
            next if done?
            if current_char == '/'
              @token.pop # remove previous asterisk
              was_closed = true
              save_token if stack?
              comment = consume_tokens
              break
            end
          end # loop

          if !was_closed
            raise Error.new("Comment was not closed: Line: #{p.line.number}")
          end

        when c == '{' && @token.empty? && tokens? && root?
          open_node(Raw_Blok.new(consume_tokens))

        when c == '{' && @token.empty? && tokens? && open_node?(Raw_Media_Query)
          new_node = Raw_Blok.new(consume_tokens)
          mq = current_node
          if mq.is_a?(Raw_Media_Query)
            mq.push new_node
          end
          open_node(new_node)

        when c == '}' && !stack? && !tokens? && open_node?(Raw_Blok)
          close_node(Raw_Blok)

        when c == ':' && stack? && open_node?(Raw_Blok)
          key = consume_stack
          upto(';'); next_char
          save_token if stack?
          values = consume_tokens
          blok = current_node(Raw_Blok)
          if blok.is_a?(Raw_Blok)
            blok.push(Raw_Property.new(key, values))
          end

        when c == '}' || c == ';'
          raise Error.new("Un-needed character: #{c} (line: #{p.line.number})")

        when c.whitespace?
          save_token unless @token.empty?

        else
          @token.push p
        end # === while

      end # while !done?

      if !root?
        node = current_node
        if node
          raise Error.new("Not properly closed: #{node.english_name}")
        end
      end

      if stack?
        raise Error.new("Unknown value: ", @token.pos_summary(@token.to_s))
      end

      if tokens?
        raise Error.new("Unknown value: ", consume_tokens.join(' '))
      end

      @nodes
    end # === def parse

    # stacks chars upto, and including, 'target',
    # thereby setting 'current_raw_char' to the char after
    # 'target'
    def through(target : Char)
      upto(target)
      @token.push current_position
      next_char
    end # === def through

    # stacks chars upto, but not including, 'target',
    # thereby setting 'target' == 'current_raw_char'
    def upto(target : Char)
      was_found = false

      while !done?
        p = current_position
        c = current_char

        case
        when c == target
          was_found = true
          break

        when (c == '\'' || c == '"')
          @token.push p
          through(c);

        when c.whitespace?
          save_token if stack?
          next_char

        else
          @token.push p
          next_char
        end # === case
      end # === while

      if !was_found
        case target
        when '\'', '"'
          raise Error.new("String not closed: #{target.inspect} (#{@token.pos_summary})")
        else
          raise Error.new("Missing character: #{target.inspect} (#{@token.pos_summary})")
        end
      end

      return was_found
    end # === def goto

    def root?
      @open_nodes.empty?
    end # === def root?

    def done?
      !@reader.has_next?
    end # === def done?

    def tokens?
      !@tokens.empty?
    end # === def tokens?

    def stack?
      !@token.empty?
    end # === def stack?

    def open_node?(klass)
      @open_nodes.last?.class == klass
    end

    def open_node(x)
      if root? 
        if x.is_a?(ROOT_NODE_TYPES)
          @nodes.push x
        else
          raise Error.new("#{x.english_name} can't be opened at the top of a CSS document.")
        end
      end
      @open_nodes.push x
      self
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

    def current_position
      Position.new(@origin, @reader.pos, @reader.current_char)
    end

    def save_token
      if @token.empty?
        raise Exception.new("Trying to save an empty stack of characters.")
      end
      c = consume_stack
      @tokens.push c
      c
    end # === def save_token

    def consume_tokens
      t = @tokens
      @tokens = Deque(Token).new
      t
    end # === def consume_tokens

    def consume_stack
      raise Exception.new("Trying to consume an empty stack.") if @token.empty?
      s = @token.freeze!
      @token = Token.new
      s
    end # === def consume_stack

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

    def to_s(io)
      @nodes.each_with_index { |x, i|
        io << ' ' if i != 0
        x.to_s(io)
      }
      io
    end # === def print

  end # === class Parser

end # === module DA_CSS
