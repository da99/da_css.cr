
module DA_CSS

  struct Number

    RANGE = '0'..'9'
    @raw : Token

    def initialize(@raw)
      if @raw.size > 8
        raise Number::Invalid.new(@raw)
      end
    end # === def initialize

    def to_s
      @raw.to_s
    end # === def to_s

    def print(printer : Printer)
      @raw.print printer
    end # === def print

    def self.looks_like?(chars : Token)
      first = chars.first
      last  = chars.last

      case first
      when '-', '.', RANGE
        true
      else
        return false
      end # === case first

      case last
      when RANGE
        true
      else
        return false
      end
    end # === def self.looks_like?

  end # === struct Number

end # === module DA_CSS
