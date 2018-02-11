
module DA_CSS

  struct Slash

    getter token : Token

    def initialize(t : Token)
      if !self.class.looks_like?(t)
        raise CSS_Author_Error.new("Expecting a slash at: #{t.summary}")
      end
      @token = t
    end # === def initialize

    def to_s(io)
      io << '/'
    end

    def inspect(io)
      io << "Slash[#{@token.first.summary}]"
    end

    def self.looks_like?(t : Token)
      t.size == 1 && t.first.char == '/'
    end

  end # === struct Slash

end # === module DA_CSS
