
module DA_CSS

  struct Color

    @raw : Token
    delegate parent, to: @raw

    def initialize(@raw)
      @raw.each_with_index { |position, index|
        c = position.char
        case
        when index == 0 && c == HASH
          true
        when index > 0 && index < 9 && (UPPER_CASE_LETTERS.includes?(c) || LOWER_CASE_LETTERS.includes?(c) || NUMBERS.includes?(c))
          true
        else
          raise Invalid_Color.new(@raw)
        end
      }
    end # === def initialize

    def to_s(io)
      @raw.to_s(io)
    end # === def to_s

    def print(printer : Printer)
      printer.raw! to_s
      self
    end # === def print

    def self.looks_like?(t : Token)
      t.first.char == HASH
    end # === def self.looks_like?
  end # === struct Color

end # === module DA_CSS
