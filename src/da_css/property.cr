
module DA_CSS

  struct Property

    # =============================================================================
    # Instance Methods
    # =============================================================================

    getter key : Token
    getter values : PROPERTY_VALUE

    def initialize(raw : Token)
      raw_key = Token.new
      raw_val = Token.new
      fill_key = true
      raw.reader {
        c = current.char
        case
        when c == ':' && fill_key
          fill_key = false
        else
          if fill_key
            raw_key.push current
          else
            raw_val.push current
          end
        end
      }
      @key = self.class.validate_key!(raw_key.strip!)
      @values = Property_Value_Splitter.new(raw_val.strip!).values
    end # === def initialize

    def to_s(io)
      @key.to_s(io)
      io << ": "
      @values.join(SPACE, io)
      io << ";"
    end

    # =============================================================================
    # Class Methods
    # =============================================================================

    def self.validate_key!(t : Token)
      t.reader { |r|
        c = current.char
        case c
        when LOWER_CASE_LETTERS, '_', '-', NUMBERS
          true
        else
          raise CSS_Author_Error.new("Invalid character in property name #{t.to_s.inspect}: #{current.summary}")
        end
      }
      t
    end # === def self.validate_key!

  end # === struct Selector_Token

end # === module DA_CSS
