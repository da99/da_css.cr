
module DA_CSS

  module Node

    struct Selector_With_Body

      getter head        : Node::Selector
      getter body        : Parser = Parser.new
      getter parent      : Parser

      def initialize(arr : Char_Deque_Deque, @parent : Parser)
        @head = Node::Selector.new(arr)
        @body = body = Parser.new
        body.parent = self
        body.parse
      end # === def initialize

      def parent_node?
        !@parent.parent_node.is_a?(Nil)
      end # === def parent_node?

      def parent_node
        @parent.parent_node
      end

      def print(printer : Printer)
        printer.new_line(parent)
        head.print printer
        printer.raw! " {"
        DA_CSS::Printer.new(printer, body).run
        printer.new_line(parent)
        printer.raw! "}"
      end # === def print

    end # === struct Selector

  end # === module Node

end # === module DA_CSS

