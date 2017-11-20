
module DA_CSS

  module Node

    struct Empty_Array

      def empty?
        true
      end # === def empty?

      def each
        0.times { |i| yield i }
      end

    end # === struct Empty_Array

  end # === module Node

end # === module DA_CSS
