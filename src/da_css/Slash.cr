
module DA_CSS

  struct Slash

    @raw : Token

    def initialize(t : Token)
      if !self.class.looks_like?(t)
        raise CSS_Author_Error.new("Expecting a slash at: #{t.summary}")
      end
      @raw = t
    end # === def initialize

    def to_s(io)
      io << '/'
    end

    def inspect(io)
      io << "Slash[#{@raw.first.summary}]"
    end

    def self.looks_like?(t : Token)
      t.size == 1 && t.first.char == '/'
    end

  end # === struct Slash

end # === module DA_CSS
