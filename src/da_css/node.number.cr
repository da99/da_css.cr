
module DA_CSS

  module Node

    struct Number

      RANGE = ('0'.hash)..('9'.hash)
      @raw : Codepoints

      def initialize(@raw)
        if @raw.size > 8
          raise Invalid_Number.new(@raw)
        end
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def self.looks_like?(codepoints : Codepoints)
        first = codepoints.first
        last  = codepoints.last

        case first
        when '-'.hash, '.'.hash, RANGE
          true
        else
          return false
        end # === case first

        case last
        when RANGE
          true
        else
          return false
        end
      end # === def self.looks_like?

    end # === struct Number

  end # === module Node

end # === module DA_CSS
