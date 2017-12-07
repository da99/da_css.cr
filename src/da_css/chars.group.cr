
module DA_CSS
  struct Chars
    struct Group

      include Enumerable(Chars)
      getter raw = Deque(Chars).new
      getter parent : Parser

      def initialize(@parent)
      end # === def initialize

      def join(delim = SPACE)
        @raw.reduce(Chars.new(@parent)) { |acc, x|
          acc.push(delim) unless acc.empty?
          x.each { |i| acc.push(i) }
          acc
        }
      end

      def push(x : Chars)
        @raw.push(x) unless x.empty?
        self
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

    end # === struct Group
  end # === struct Chars
end # === module DA_CSS
