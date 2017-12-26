
module DA_CSS

  struct Property

    def self.validate_key!(t : Token)
      t.each { |p|
        case p.char
        when 'a'..'z', '-'
          p
        else
          raise CSS_Author_Error.new("Invalid character for property key: #{p.summary}")
        end
      }
      t
    end # === def self.validate_key!

    def self.validate_value_token!(token : Token)
      token.each { |p|
        case p.char
        when 'a'..'z', '#', '-', '0'..'9'
          p
        else
          raise CSS_Author_Error.new("Invalid character for property value: #{p.summary}")
        end
      }
      token
    end # === def self.validate_value!

    @key : Token
    @values = Deque(Token).new

    def initialize(raw_property : Raw_Property)
      @key = self.class.validate_key!(raw_property.name)
      raw_property.values.each { |token|
        @values.push self.class.validate_value_token!(token)
      }
    end # === def initialize

    def to_s(io)
      @key.to_s(io)
      io << ": "
      @values.join(SPACE, io)
      io << ";"
    end

  end # === struct Selector_Token

end # === module DA_CSS
