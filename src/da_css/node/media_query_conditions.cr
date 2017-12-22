
module DA_CSS
  module Node
    struct Media_Query_Conditions

      @conds = Deque(Node::Media_Query_Condition | Node::Media_Query_Keyword).new

      def initialize
      end # === def initialize

      def push(x : Node::Media_Query_Condition | Node::Media_Query_Keyword)
        @conds.push x
      end # === def push

      def print(p : Printer)
        p.raw! "("
        @conds.each_with_index { |a, i|
          p.raw! ", " if i != 0
          a.print(p)
        }
        p.raw! ")\n"
      end # === def print

    end # === struct Media_Query_Conditions
  end # === module Node
end # === module DA_CSS
