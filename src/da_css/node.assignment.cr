
module DA_CSS

  module Node

    struct Assignment

      getter name  : Codepoints
      getter value : Doc

      def initialize(@name, @value)
      end # === def initialize

      def string_name
        name.to_s
      end # === def string_name

      def string_value
        @value.to_s
      end # === def string_value

    end # === struct Assignment

  end # === module Node

end # === module DA_CSS
