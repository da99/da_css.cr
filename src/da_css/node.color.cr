
module DA_CSS

  module Node

    struct Color

      HASH    = '#'
      UPPER   = 'A'..'Z'
      LOWER   = 'a'..'z'
      NUMBERS = '0'..'9'

      @raw : Chars

      def initialize(@raw)
        @raw.each_with_index { |c, index|
          cp = c.ord
          case
          when index == 0 && c == HASH
            true
          when index > 0 && index < 9 && (UPPER.includes?(c) || LOWER.includes?(c) || NUMBERS.includes?(c))
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

      def self.looks_like?(chars : Chars)
        chars.first == HASH
      end # === def self.looks_like?
    end # === struct Color

  end # === module Node

end # === module DA_CSS
