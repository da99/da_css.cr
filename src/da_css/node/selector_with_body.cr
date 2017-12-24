
module DA_CSS

  module Node

    struct Selector_With_Body

      getter head : Node::Selector
      getter body = Deque(Node::Property).new

      def initialize(arr : Position_Deque)
        @head = Node::Selector.new(arr)
      end # === def initialize

      def push(x : Node::Property)
        body.push x
      end # === def push

      def print(printer : Printer)
        printer.new_line
        head.print printer
        printer.raw! " {\n"
        body.each { |x|
          x.print(printer)
        }
        printer.raw! "\n}\n"
      end # === def print

    end # === struct Selector

  end # === module Node

end # === module DA_CSS

