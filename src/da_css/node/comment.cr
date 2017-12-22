
module DA_CSS

  module Node

    struct Comment

      getter raw : A_Char_Deque

      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def print(printer : Printer)
        printer.raw! "\n/*\n"
        @raw.print(printer)
        printer.raw! "\n*/\n"
      end # === def print

    end # === struct Comment

  end # === module Node

end # === module DA_CSS
