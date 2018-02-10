


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

    getter nodes = Deque(Block).new

    # A Char::Reader is used because it adds
    # protection against invalid codepoints.
    getter raw : Token
    delegate done?, to: @reader

    def initialize(origin : String)
      @raw = Token.new(origin)
    end # === def initialize

    def parse
      @raw.reader { |reader|
        p = current
        c = p.char

        case

        when p.whitespace? # PARSE: comment
          next

        when c == '/' && peek?('*')
          reader.next # == skip asterisk
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
          nodes.push(
            Block.new(
              reader.consume_upto_then_next(OPEN_BRACKET),
              reader.consume_upto_then_next(CLOSE_BRACKET)
            )
          )
        end # case

      } # reader

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
