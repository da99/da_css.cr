
module DA_CSS
  struct Char_Deque_Deque

    include Enumerable(Char_Deque)
    getter raw = Deque(Char_Deque).new
    getter parent : Parser

    def initialize(@parent)
    end # === def initialize

    def join(delim = SPACE)
      @raw.reduce(Char_Deque.new(@parent)) { |acc, x|
        acc.push(delim) unless acc.empty?
        x.each { |i| acc.push(i) }
        acc
      }
    end

    def push(x : Char_Deque)
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

  end # === struct Char_Deque_Deque
end # === module DA_CSS
