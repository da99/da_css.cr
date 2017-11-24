
module DA_CSS

  module Node

    struct Selector_With_Body

      getter head : Node::Selector
      getter body : Doc

      def initialize(arr : Codepoints::Array, @body)
        @head = Node::Selector.new(arr)
      end # === def initialize

      def print(printer : Printer)
        printer.new_line
        head.print printer
        printer.raw! " {"
        DA_CSS::Printer.new(printer, body).run
        printer.raw! "\n}"
      end # === def print

    end # === struct Selector

  end # === module Node

end # === module DA_CSS
