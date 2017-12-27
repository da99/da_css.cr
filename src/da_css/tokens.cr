
module DA_CSS
  struct Tokens

    include Indexable(Token)

    @raw = Deque(Token).new
    delegate empty?, pop, first, first?, last, last?, to: @raw

    def each
      @raw.each { |t|
        yield t
      }
    end # === def each

    def <<(t : Token)
      @raw << t
    end # === def <<

    def push(t : Token)
      @raw.push t
    end # === def push

    def each_position
      @raw.each { |t|
        t.each { |position|
          yield t
        }
      }
    end # === def each_position

  end # === struct Tokens
end # === module DA_CSS
