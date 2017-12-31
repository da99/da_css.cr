
module DA_CSS

  struct Number

    @raw : Token

    def initialize(@raw)
      if @raw.size > 8
        raise raise CSS_Author_Error.new("Invalid number: #{@raw.to_s.inspect} (#{@raw.inspect})")
      end
      @raw.each_with_index { |p, index|
        c = p.char
        case
        when index.zero? && (c == '-' || c == '.')
          true
        when NUMBERS.includes?(c)
          true
        else
          raise CSS_Author_Error.new("Invalid number: #{@raw.summary}")
        end
      }
    end # === def initialize

    def to_s
      @raw.to_s
    end # === def to_s

    def print(printer : Printer)
      @raw.print printer
    end # === def print

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
