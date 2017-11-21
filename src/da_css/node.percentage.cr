
module DA_CSS

  module Node

    struct Percentage

      @raw : Codepoints
      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

    end # === struct Percentage

  end # === module Node

end # === module DA_CSS
