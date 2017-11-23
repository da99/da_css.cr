
module DA_CSS

  module Node

    struct Unit

      RANGE = 1..3
      LETTERS = ('a'.hash)..('z'.hash)

      @raw    : Codepoints
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

      def self.looks_like?(cp : Codepoints)
        RANGE.includes?(cp.size) && cp.all?(LETTERS)
      end # === def self.looks_like?

    end # === struct Unit

  end # === module Node

end # === module DA_CSS
