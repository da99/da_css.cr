
module DA_CSS

  module Node

    struct Percentage

      @raw : A_Char_Deque

      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def print(printer : Printer)
        @raw.print(printer)
        self
      end # === def print

      def self.looks_like?(cp : A_Char_Deque)
        first = cp.first
        last = cp.first

        return false if cp.size > 8 || cp.size < 2

        case first
        when Number::RANGE, '-', '.'
          true
        else
          return false
        end

        last == '%'
      end # === def self.looks_like?

    end # === struct Percentage

  end # === module Node

end # === module DA_CSS
