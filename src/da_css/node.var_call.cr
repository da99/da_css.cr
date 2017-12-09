
module DA_CSS

  module Node

    struct Var_Call

      @raw : Char_Deque
      getter parent : Parser
      def initialize(@raw : Char_Deque, @parent : Parser)
      end # === def initialize

      def print(printer : Printer)
        io = IO::Memory.new
        @raw.each { |x|
          case x
          when 'a'..'z', 'A'..'Z', '0'..'9', '_', '-'
            io << x
          else
            next
          end
        }
        printer.raw! "?"
        printer.raw! io.to_s
        printer.raw! "?"
        self
      end # === def print

    end # === struct Var_Call

  end # === module Node

end # === module DA_CSS
