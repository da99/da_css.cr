
module DA_CSS

  module Node

    struct Unit

      RANGE = 1..3
      LETTERS = 'a'..'z'

      @raw    : Position_Deque
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

      def self.looks_like?(chars : Position_Deque)
        RANGE.includes?(chars.size) && chars.all?(LETTERS)
      end # === def self.looks_like?

    end # === struct Unit

  end # === module Node

end # === module DA_CSS
