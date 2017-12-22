
module DA_CSS

  struct A_Char

    getter parent : Parser
    getter pos    : Int32
    getter raw    : Char

    delegate whitespace?, to: @char

    def initialize(@raw, @pos, @parent)
    end # === def initialize

    def line
      Line.new(pos, parent)
    end # === def line

    def to_chr
      @raw
    end # === def to_chr

  end # === struct Pos

end # === module DA_CSS
