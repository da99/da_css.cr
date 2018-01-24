
module DA_CSS

  struct Selector

    def initialize(t : Token)
      @raw = t
    end # === def initialize

    def to_s(io)
      @raw.to_s(io)
    end # === def to_s

  end # === struct Selector

end # === module DA_CSS
