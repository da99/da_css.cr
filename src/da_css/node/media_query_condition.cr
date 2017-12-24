
module DA_CSS

  module Node

    struct Media_Query_Condition

      alias VALUE_TYPES = Number_Unit | Number | Percentage | Keyword

      @name : Token
      @vals = Deque(VALUE_TYPES).new

      def initialize(@name)
      end # === def initialize

      def push(x : VALUE_TYPES)
        @vals.push x
      end # === def push

      def print(p : Printer)
        p.raw! @name.to_s
        p.raw! ":"
        @vals.each_with_index { |v, i|
          p.raw! " "
          v.print p
        }
      end # === def print

    end # === struct Media_Query_Condition

  end # === module Node

end # === module DA_CSS
