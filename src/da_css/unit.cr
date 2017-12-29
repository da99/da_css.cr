
module DA_CSS

  struct Unit

    RANGE = 1..3
    LETTERS = 'a'..'z'

    @raw    : Token
    @string : String

    def initialize(@raw)
      string = @string = @raw.to_s
      case string
      when "px", "em", "mm", "cm", "in",
        "pt", "pc", "ex", "ch", "rem",
        "vw", "vh", "deg", "s"
        true
      else
        raise Invalid_Unit.new(@string)
      end
    end # === def initialize

    def to_s
      @string
    end # === def to_s

    def print(printer : Printer)
      printer.raw! @string
      self
    end # === def print

    def self.looks_like?(chars : Token)
      RANGE.includes?(chars.size) && chars.all?(LETTERS)
    end # === def self.looks_like?

  end # === struct Unit

end # === module DA_CSS
