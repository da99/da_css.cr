
module DA_CSS

  module Node

    struct Unknown

      @raw : String
      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw
      end # === def to_s

    end # === struct Unknown

  end # === module Node

end # === module DA_CSS
