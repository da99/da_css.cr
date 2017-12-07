
module DA_CSS

  module Node

    class Invalid_Function_Call < Exception

      def initialize(chars : Chars | String)
        @message = "Invalid function call: #{chars.to_s}"
      end # === def initialize

    end # === class Invalid_Function_Call

    struct Function_Call

      @name : String
      @args : Parser
      getter parent : Parser

      def initialize(raw_name : Chars, @parent : Parser)
        @name = raw_name.to_s
        @args = doc = Parser.new
        doc.parent = self
        doc.parse
      end # === def initialize

      def to_s
        "#{@name}(#{@args.nodes.map(&.to_s).join(",")})"
      end # === def to_s

      def print(printer : Printer)
        printer.raw! @name, "("
        @args.nodes.each_with_index { |x, i|
          printer.raw!(", ") if i != 0
          x.print(printer)
        }
        printer.raw! ")"
      end # === def print
    end # === struct Function_Call

  end # === module Node

end # === module DA_CSS
