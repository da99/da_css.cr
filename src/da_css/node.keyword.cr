
module DA_CSS

  module Node

    struct Keyword

      @raw : String
      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw
      end # === def to_s

      def print(printer : Printer)
        printer.raw! @raw
      end # === def print

    end # === struct Keyword

  end # === module Node

end # === module DA_CSS
