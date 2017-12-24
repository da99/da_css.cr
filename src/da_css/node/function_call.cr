
module DA_CSS

  module Node

    class Invalid_Function_Call < Exception

      def initialize(chars : Position_Deque | String)
        @message = "Invalid function call: #{chars.to_s}"
      end # === def initialize

    end # === class Invalid_Function_Call

    struct Function_Call

      @name : String
      @args = Deque(Node::Text).new

      def initialize(raw_name : Position_Deque)
        @name = raw_name.to_s
      end # === def initialize

      def to_s
        "#{@name}(#{@args.map(&.to_s).join(",")})"
      end # === def to_s

      def push(x : Node::Text)
        @args.push x
      end # === def push

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
