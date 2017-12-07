
module DA_CSS

  struct Chars

    struct Array

      include Enumerable(Chars)

      getter raw = Deque(Chars).new

      def initialize
      end # === def initialize

      def initialize(@raw)
      end # === def initialize

      def join(delim = SPACE)
        @raw.reduce(Chars.new) { |acc, x|
          acc.push delim unless acc.empty?
          x.each { |i|
            acc.push i
          }
          acc
        }
      end

      def push(x : Chars)
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

  end # === class Chars

end # === module DA_CSS
