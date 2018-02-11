
module DA_CSS

  struct A_Number

    getter token : Token

    def initialize(@token)
      if @token.size > 7
        raise raise CSS_Author_Error.new("Invalid number: #{@token.summary}")
      end
      last_i = @token.size - 1
      minus_signs = 0
      periods = 0
      @token.each_with_index { |p, index|
        c = p.char
        (minus_signs += 1) if c == '-'
        (periods += 1) if c == '.'
        case
        when last_i && NUMBERS.includes?(c)
          true
        when index.zero? && (c == '-' || c == '.')
          true
        when periods < 2 && c == '.' && index < last_i
          true
        when NUMBERS.includes?(c)
          true
        else
          raise CSS_Author_Error.new("Invalid number: #{@token.summary}")
        end
      }
    end # === def initialize

    def inspect(io)
      io << self.class.name << "["
      @token.inspect(io)
      io << "]"
    end # === def inspect

    def to_s(io)
      @token.to_s(io)
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      first = t.first.char
      last  = t.last.char

      case first
      when '-', '.', NUMBERS
        true
      else
        return false
      end # === case first

      case last
      when NUMBERS
        true
      else
        return false
      end
    end # === def self.looks_like?

  end # === struct Number

end # === module DA_CSS
