
module DA_CSS

  # A raw position: contains a char and a position
  # in the original string (ie CSS doc).
  struct Position

    getter origin : String
    getter num    : Int32
    getter char   : Char

    delegate whitespace?, to: @char

    def initialize(@origin, @num, @char)
    end # === def initialize

    def line
      Line.new(self)
    end # === def line

    def to_chr
      @char
    end # === def to_chr

    def inspect(io)
      io << "#{self.class}[#{char.inspect} @#{num}]"
    end # === def inspect

  end # === struct Position

end # === module DA_CSS
