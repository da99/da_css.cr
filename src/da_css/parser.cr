


module DA_CSS

  # Right now the "Parser" is a combined lexer and parser.
  class Parser

    # =============================================================================
    # Class
    # =============================================================================

    def self.parse(origin)
      new(origin).parse
    end

    # =============================================================================
    # Instance
    # =============================================================================

    getter nodes          = Deque(Blok).new

    # A Char::Reader is used because it adds
    # protection against invalid codepoints.
    getter reader : Token_Reader
    delegate done?, to: @reader

    def initialize(raw : String)
      @reader = Token_Reader.new(raw)
    end # === def initialize

    def parse
      while !reader.done?
        p = reader.current
        c = p.char
        reader.next

        case
        # PARSE: comment
        when p.whitespace?
          next
        when c == '/' && reader.current.char == '*'
          reader.next unless reader.done? # == skip asterisk
          was_closed = false
          while !reader.done?
            while !reader.done?
              reader.next!
              break if reader.done?
              if reader.current.char == '*'
                reader.next! unless reader.done?
                break
              end
            end
            break if reader.done?
            if reader.current.char == '/'
              reader.next
              was_closed = true
              break
            end
          end # loop

          if !was_closed
            raise Error.new("Comment was not closed: #{p.summary}")
          end

        else
          raw_selector = reader.consume_upto(OPEN_BRACKET)
          if reader.done?
            raise CSS_Author_Error.new("Selector has missing body: #{raw_selector.summary}")
          end
          reader.next

          raw_body = reader.consume_upto(CLOSE_BRACKET)
          if reader.done?
            raise CSS_Author_Error.new("Block not properly closed: #{raw_body.summary}")
          end
          reader.next

          nodes.push Blok.new(raw_selector, raw_body)

        end # === while

      end # while !done?

      @nodes
    end # === def parse


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
