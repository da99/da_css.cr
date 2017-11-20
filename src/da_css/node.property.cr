
module DA_CSS

  module Node

    struct Property

      getter key   : Key
      getter value : Doc

      def initialize(raw_key : Codepoints, @value)
        @key = Key.new(raw_key)
      end # === def initialize

      struct Key

        @raw : Codepoints
        def initialize(@raw)
          @raw.each { |i| Key.valid_char!(i) }
        end # === def initialize

        def self.valid_char!(i : Int32)
          case i
          when ('a'.hash)..('z'.hash), '-'.hash
            true
          else
            raise Invalid_Char.new(i, "Invalid char for property name: ")
          end
        end # === def self.valid_char?

        def each
          @raw.each { |i| yield i }
        end

      end # === struct Key

    end # === struct Property

  end # === module Node

end # === module DA_CSS
