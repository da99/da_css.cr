
module DA_CSS

  struct Property

    # =============================================================================
    # Instance Methods
    # =============================================================================

    @key : Token
    @values : Tokens

    def initialize(raw_property : Raw_Property)
      @key = self.class.validate_key!(raw_property.name)
      @values = self.class.validate_value!(raw_property.value)
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

    def self.validate_value!(token : Token)
      token.split_with_splitter { |p, s|
        c = p.char
        case
        when c.whitespace? || s.last?
          if s.token?
            s << p unless c.whitespace?
            s << s.consume_token
          end

        when c == OPEN_PAREN
          if !s.token?
            raise CSS_Author_Error.new("Missing function call name at #{p.summary}")
          end
          name = s.consume_token
          s.next
          arg = s.consume_upto(CLOSE_PAREN)
          s.tokens << Function_Call.new(name, arg).to_token

        else
          s << p
        end
      }
    end # === def self.validate_value!


  end # === struct Selector_Token

end # === module DA_CSS
