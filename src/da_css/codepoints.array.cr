
module DA_CSS

  struct Codepoints

    class Array

      include Enumerable(Codepoints)

      getter raw : ::Array(Codepoints) = [] of Codepoints

      def initialize
      end # === def initialize

      def initialize(@raw)
      end # === def initialize

      def join(delim = SPACE)
        @raw.reduce(Codepoints.new) { |acc, x|
          acc.push delim unless acc.empty?
          x.each { |i|
            acc.push i
          }
          acc
        }
      end

      def push(x : Codepoints)
        @raw.push x
      end # === def push

      def empty?
        @raw.empty?
      end # === def empty?

      def size
        @raw.size
      end # === def size

      def each
        @raw.each { |c| yield c }
      end

    end # === class Array

  end # === class Codepoints

end # === module DA_CSS
