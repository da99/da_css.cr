
module DA_CSS

  module Node

    class Invalid_Function_Call < Exception

      def initialize(cp : Codepoints)
        @message = "Invalid function call: #{cp.to_s}"
      end # === def initialize

      def initialize(str : String)
        @message = "Invalid function call: #{str}"
      end # === def initialize

    end # === class Invalid_Function_Call

    struct Function_Call

      @name : String
      @args : Doc

      def initialize(raw_name : Codepoints, raw_args : Doc)
        @name = raw_name.to_s
        @args = raw_args
      end # === def initialize

      def to_s
        "#{@name}(#{@args.map(&.to_s).join(",")})"
      end # === def to_s

      def print(printer : Printer)
        printer.raw! @name, "("
        @args.each_with_index { |x, i|
          printer.raw!(", ") if i != 0
          x.print(printer)
        }
        printer.raw! ")"
      end # === def print
    end # === struct Function_Call

  end # === module Node

end # === module DA_CSS
