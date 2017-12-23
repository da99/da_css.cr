
module DA_CSS

  struct A_Char

    getter origin : Origin
    getter pos    : Int32
    getter raw    : Char

    delegate whitespace?, to: @raw

    def initialize(@origin)
      @pos = @origin.pos
      @raw = @origin.current_raw_char
    end # === def initialize

    def initialize(@raw, @pos, @origin)
    end # === def initialize

    def line
      Line.new(self)
    end # === def line

    def to_chr
      @raw
    end # === def to_chr

    def inspect(io)
      io << "#{self.class}[#{raw.inspect} @#{pos}]"
    end # === def inspect

  end # === struct Pos

end # === module DA_CSS
