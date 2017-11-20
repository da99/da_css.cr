
module Node

  struct Comment

    getter raw : Codepoints

    def initialize(@raw)
    end # === def initialize

    def to_s
      @raw.to_s
    end # === def to_s

  end # === struct Comment

end # === module Node
