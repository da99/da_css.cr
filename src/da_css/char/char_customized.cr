
module DA_CSS

  struct Char_Customized

    getter parent : Parser
    getter pos    : Int32
    getter char   : Char

    def initialize(@char, @pos, @parent)
    end # === def initialize

    def line
      Line.new(pos, parent)
    end # === def line

    def to_chr
      @char
    end # === def to_chr

  end # === struct Pos

end # === module DA_CSS
