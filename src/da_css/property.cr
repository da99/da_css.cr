
module DA_CSS

  struct Property

    # =============================================================================
    # Instance Methods
    # =============================================================================

    @key : Token
    @values : PROPERTY_VALUE

    def initialize(raw_property : Raw_Property)
      @key = self.class.validate_key!(raw_property.name)
      @values = Property_Value_Splitter.new(raw_property.value).values
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
          {% for x in system("cat #{__DIR__}/propertys.txt").split %}
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
