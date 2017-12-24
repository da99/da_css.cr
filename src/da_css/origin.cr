
module DA_CSS

  class Origin

    getter raw    : String

    def initialize(@raw)
    end # === def initialize

    def parse
      Parser.new(self).parse
    end # === def parse

    def inspect(io)
      io << "Origin["
      io << @raw[0..15].inspect
      io << "]"
    end # === def inspect

  end # === class Origin

end # === module DA_CSS
