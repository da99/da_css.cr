
module DA_CSS

  module Node

    struct Media_Query

      @name : Token
      @args = Deque(ARG_TYPES).new
      @body = Deque(Node::Selector_With_Body).new

      def initialize(@name)
      end # === def initialize

      def to_s(io)
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
