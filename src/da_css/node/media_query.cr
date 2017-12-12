
module DA_CSS

  module Node

    struct Media_Query

      @name : Char_Deque
      @args = Deque(Node::Property).new
      @body = Deque(Node::Selector_With_Body).new

      def initialize(@name)
      end # === def initialize

      def push(x : Node::Property)
        @args.push x
      end # === def push

      def push(x : Node::Selector_With_Body)
        @body.push x
      end # === def push

      def print(p : Printer)
        p.raw! "@"
        p.raw! @name.to_s
        p.raw! " ("
        @args.each_with_index { |a, i|
          p.raw! ", " if i != 0
          a.print(p)
        }
        p.raw! ") {\n"
        @body.each { |x|
          x.print(p)
        }
        p.raw! "\n}"
      end # === def print

    end # === struct Media_Query

  end # === module Node

end # === module DA_CSS
