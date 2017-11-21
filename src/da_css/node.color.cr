
module DA_CSS

  module Node

    struct Color

      @raw : Codepoints
      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

    end # === struct Color

  end # === module Node

end # === module DA_CSS
