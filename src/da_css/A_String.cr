
module DA_CSS

  struct A_String

    # =============================================================================
    # Instance
    # =============================================================================

    getter token : Token

    def initialize(@token)
      self.class.valid!(@token)
    end # === def initialize

    def to_token
      @token
    end

    def inspect(io)
      io << self.class.name
      io << "["
      @token.inspect(io)
      io << "]"
    end # === def inspect

    def to_s(io)
      last_i = @token.size - 1
      @token.each_with_index { |p, i|
        if i.zero? || i == last_i
          io << '\''
          next
        end
        io << p.char
      }
      io
    end

    def print(printer : Printer)
      printer.raw! "'"
      @token.print printer
      printer.raw! "'"
      self
    end # === def print

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      return false if t.size < 1
      a = t.first.char
      z = t.last.char
      (a == z == '\'') || (a == z == '"')
    end # === def self.looks_like?

    def self.valid!(t : Token)
      last_i = t.size - 1
      t.each_with_index { |p, i|
        c = p.char
        if i.zero? || i == last_i
          case c
          when '\'', '"'
            true
          else
            raise CSS_Author_Error.new("Strings must start with a quotation character (single or double): #{t.summary}")
          end
          next
        end

        case
        when DA_CSS.unsafe_ascii?(c)
          raise CSS_Author_Error.new("String can't contain this character: #{p.summary}")
        end
      }
    end # === def valid!

  end # === struct A_String

end # === module DA_CSS
