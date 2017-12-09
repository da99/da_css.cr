
module DA_CSS

  module Node

    struct Keyword

      @raw : Char_Deque
      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def print(printer : Printer)
        printer.raw! to_s
      end # === def print

    end # === struct Keyword

  end # === module Node

end # === module DA_CSS
