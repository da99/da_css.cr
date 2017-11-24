
module DA_CSS

  module Node

    struct Color

      HASH = '#'.hash
      UPPER = ('A'.hash)..('Z'.hash)
      LOWER = ('a'.hash)..('z'.hash)
      NUMBERS = ('0'.hash)..('9'.hash)

      @raw : Codepoints

      def initialize(@raw)
        @raw.each_with_index { |x, i|
          case
          when i == 0 && x == HASH
            true
          when i > 0 && i < 9 && (UPPER.includes?(x) || LOWER.includes?(x) || NUMBERS.includes?(x))
            true
          else
            raise Invalid_Color.new(@raw)
          end
        }
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def print(printer : Printer)
        @raw.print(printer)
        self
      end # === def print

      def self.looks_like?(cp : Codepoints)
        cp.first == '#'.hash
      end # === def self.looks_like?
    end # === struct Color

  end # === module Node

end # === module DA_CSS
