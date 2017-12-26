
module DA_CSS

  struct Selector_Token

    def self.validate!(p : Position)
      case p.char
      when 'a'..'z', '.', '#', '_', '-'
        p
      else
        raise CSS_Author_Error.new("Invalid character for a selector: #{p.summary}")
      end
    end # === def validate!

    @raw : Token
    def initialize(@raw)
      @raw.each { |p|
        self.class.validate! p
      }
    end # === def initialize

    def to_s(io)
      @raw.to_s(io)
    end # === def to_s

  end # === struct Selector_Token

end # === module DA_CSS
