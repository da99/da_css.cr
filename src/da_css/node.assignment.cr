
module DA_CSS

  module Node

    struct Assignment

      getter name  : Chars
      getter value : Parser
      getter parent : Parser

      def initialize(@name, @parent : Parser)
        raise Exception.new("Assignment has missing var name.") if @name.empty?
        @value = body = Parser.new
        body.parent = self
        body.parse
        if !body.nodes?
          raise Exception.new("No value specified for var: #{@name.to_s.inspect}")
        end
      end # === def initialize

      def string_name
        name.to_s
      end # === def string_name

      def string_value
        @value.to_s
      end # === def string_value

      def print(printer : Printer)
        printer.data[string_name] = string_value
        self
      end # === def write

    end # === struct Assignment

  end # === module Node

end # === module DA_CSS
