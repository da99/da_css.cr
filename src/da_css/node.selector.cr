
module DA_CSS

  module Node

    struct Selector

      include Enumerable(Int32)

      @raw : Array(Selector::Partial)
      def initialize(arr : Codepoints::Array)
        @raw = arr.map { |codepoints|
          Selector::Partial.new(codepoints)
        }
      end # === def initialize

      def each
        @raw.each_with_index { |partial, pos|
          yield(' '.hash) if pos != 0
          partial.each { |i|
            yield i
          }
        }
      end # === def each

      struct Partial

        include Enumerable(Int32)
        @raw : Codepoints
        def initialize(@raw)
        end

        def each
          @raw.each { |i|
            yield i
          }
        end # === def each

      end # === struct Partial

      def self.valid_char?(i : Int32)
        case i
        when ('a'.hash)..('z'.hash), ('0'.hash)..('9'.hash), '.'.hash, '-'.hash, '_'.hash
          true
        else
          raise Invalid_Char.new(i)
        end
      end # === def self.valid_char?
    end # === struct Selector

  end # === module Node

end # === module DA_CSS
