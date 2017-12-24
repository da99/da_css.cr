
module DA_CSS

  module Node

    struct Unknown

      @raw : Token
      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def print(printer : Printer)
        printer.raw! to_s
        self
      end # === def print

    end # === struct Unknown

  end # === module Node

end # === module DA_CSS
