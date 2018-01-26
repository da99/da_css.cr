
module DA_CSS

  struct Property

    # =============================================================================
    # Instance Methods
    # =============================================================================

    @key : Token
    @values : PROPERTY_VALUE

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
      @key = self.class.validate_key!(raw_key)
      @values = Property_Value_Splitter.new(raw_val).values
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
      word = t.to_s
      {% begin %}
        case word
          {% for x in system("cat #{__DIR__}/config/propertys.txt").split %}
            {% if !x.empty? %}
            when "{{x.id}}"
              :accepted
            {% end %}
          {% end %}
        else
          raise CSS_Author_Error.new("Invalid property key: #{t.summary}")
        end
      {% end %}
      t
    end # === def self.validate_key!

  end # === struct Selector_Token

end # === module DA_CSS
