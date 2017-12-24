
module DA_CSS

  module Node

    struct Media_Query

      alias ARG_TYPES = Media_Query_Conditions | Media_Query_Keyword | Media_Query_Comma
      @name : Token
      @args = Deque(ARG_TYPES).new
      @body = Deque(Node::Selector_With_Body).new

      def initialize(@name)
      end # === def initialize

      def push(x : Node::Media_Query_Condition)
        conds = @args.last
        case conds
        when Node::Media_Query_Conditions
          conds.push x
        end
      end # === def push

      def push(x : ARG_TYPES)
        @args.push x
      end # === def push

      def push(x : Node::Selector_With_Body)
        @body.push x
      end # === def push

      def print(p : Printer)
        p.raw! "@"
        p.raw! @name.to_s
        @args.each_with_index { |arg, i|
          p.raw! " " unless arg.is_a?(Node::Media_Query_Comma)
          arg.print(p)
        }
        p.raw! " {\n"
        @body.each { |x|
          x.print(p)
        }
        p.raw! "\n}\n"
      end # === def print

    end # === struct Media_Query

  end # === module Node

end # === module DA_CSS
