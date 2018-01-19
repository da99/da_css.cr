


module DA_CSS

  # Right now the "Parser" is a combined lexer and parser.
  class Parser

    def self.parse(origin)
      new(origin).parse
    end

    alias ROOT_NODE_TYPES = Raw_Media_Query | Raw_Blok
    alias OPEN_NODE_TYPES = ROOT_NODE_TYPES

    getter nodes = Deque(ROOT_NODE_TYPES).new

    @token      = Token.new
    @open_nodes = Deque(OPEN_NODE_TYPES).new

    # A Char::Reader is used because it adds
    # protection against invalid codepoints.
    @reader : Token_Reader
    delegate done?, to: @reader

    def initialize(raw : String)
      @reader = Token_Reader.new(raw)
    end # === def initialize

    private def r
      @reader
    end

    def parse
      while !r.done?
        p = r.current
        c = p.char
        r.next

        case
        when c == '@' && !token? && root?
          r.consume_upto('{', @token); r.next
          open_node(Raw_Media_Query.new(consume_token))

        when c == '}' && open_node?(Raw_Media_Query) && !token?
          close_node(Raw_Media_Query)

        # PARSE: comment
        when c == '/' && r.current.char == '*' && !token?
          r.next # == skip asterisk
          was_closed = false
          comment    = Token.new
          while !r.done?
            while !r.done?
              r.next!
              break if r.done?
              if r.raw_char == '*'
                r.next! unless r.done?
                break
              end
            end
            break if r.done?
            if r.raw_char == '/'
              r.next
              was_closed = true
              break
            end
          end # loop

          if !was_closed
            raise Error.new("Comment was not closed: #{p.summary}")
          end

        when c == '{' && token? && root?
          open_node(Raw_Blok.new(consume_token))

        when c == '{' && token? && open_node?(Raw_Media_Query)
          new_node = Raw_Blok.new(consume_token)
          mq = current_node
          if mq.is_a?(Raw_Media_Query)
            mq.push new_node
          end
          open_node(new_node)

        when c == '}' && !token? && open_node?(Raw_Blok)
          close_node(Raw_Blok)

        when c == ':' && token? && open_node?(Raw_Blok)
          key = consume_token
          r.consume_upto(';', @token)
          r.next
          if !token?
            raise CSS_Author_Error.new("Empty property value for: #{key.to_s.inspect} (#{key.summary})")
          end
          values = consume_token
          blok = current_node(Raw_Blok)
          if blok.is_a?(Raw_Blok)
            blok.push(Raw_Property.new(key, values))
          end

        when c == '}' || c == ';'
          raise Error.new("Un-needed character: #{c} (line: #{p.summary})")

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

      if token?
        raise CSS_Author_Error.new("Unknown value: ", @token.summary)
      end

      @nodes
    end # === def parse


    def root?
      @open_nodes.empty?
    end # === def root?

    def token?
      !@token.empty?
    end # === def token?

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

    def consume_token
      raise Exception.new("Trying to consume an empty token.") if @token.empty?
      s = @token.freeze!
      @token = Token.new
      s
    end # === def consume_token

    def nodes?
      !@nodes.empty?
    end # === def empty?

    def inspect(io)
      io << "Parser["
      @nodes.each_with_index { |x, i|
        io << ", " if !i.zero?
        io << x.class.to_s << "(instance)"
      }
      io << "]"
    end # === def inspect

    def to_s(io)
      inspect(io)
    end # === def print

  end # === class Parser

end # === module DA_CSS
