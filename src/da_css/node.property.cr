
module DA_CSS

  module Node

    struct Property

      getter key   : Codepoints
      getter value : Doc

      def initialize(@key, @value)
      end # === def initialize

    end # === struct Property

  end # === module Node

end # === module DA_CSS
