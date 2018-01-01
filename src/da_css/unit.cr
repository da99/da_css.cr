
module DA_CSS

  struct Unit

    RANGE = 1..3
    LETTERS = 'a'..'z'

    @raw    : Token
    @string : String

    def initialize(@raw : Token)
      string = @string = @raw.to_s
      case string
      when "px", "em", "mm", "cm", "in",
        "pt", "pc", "ex", "ch", "rem",
        "vw", "vh", "deg", "s"
        true
      else
        raise CSS_Author_Error.new("Invalid unit: #{@raw.summary}")
      end
    end # === def initialize

    def inspect(io)
      io << "Unit["
      @raw.inspect(io)
      io << "]"
    end # === def inspect

    def to_s(io)
      io << @string
    end # === def to_s

    def push(p : Position)
      @raw.push p
    end # === def push

    def print(printer : Printer)
      printer.raw! @string
      self
    end # === def print

    def self.looks_like?(chars : Token)
      RANGE.includes?(chars.size) && chars.all?(LETTERS)
    end # === def self.looks_like?

  end # === struct Unit

end # === module DA_CSS
