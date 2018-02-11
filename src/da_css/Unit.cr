
module DA_CSS

  struct Unit

    RANGE = 1..3
    LETTERS = 'a'..'z'

    @raw    : Token

    def initialize(@raw : Token)
    end # === def initialize

    def inspect(io)
      io << "Unit["
      @raw.inspect(io)
      io << "]"
    end # === def inspect

    def to_s(io)
      @raw.to_s(io)
    end # === def to_s

    def push(p : Position)
      @raw.push p
    end # === def push

    def self.looks_like?(chars : Token)
      RANGE.includes?(chars.size) && chars.all?(LETTERS)
    end # === def self.looks_like?

  end # === struct Unit

end # === module DA_CSS
