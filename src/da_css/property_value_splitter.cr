
module DA_CSS

  alias PROPERTY_VALUE_TYPES = A_Number | Number_Unit | Color | Function_Call | Keyword
  alias PROPERTY_VALUE = Deque(PROPERTY_VALUE_TYPES)

  struct Property_Value_Splitter

    # =============================================================================
    # Instance
    # =============================================================================

    getter raw : Token
    getter values = PROPERTY_VALUE.new

    def initialize(@raw)
      @raw.split_with_splitter { |p, s|
        c = p.char
        case
        when c.whitespace? || s.last?
          if s.token?
            s << p unless c.whitespace?
            @values.push self.class.to_value(s.consume_token)
          end

        when c == OPEN_PAREN
          if !s.token?
            raise CSS_Author_Error.new("Missing function call name at #{p.summary}")
          end
          name = s.consume_token
          arg = s.consume_through(CLOSE_PAREN)
          @values.push Function_Call.new(name, arg)

        else
          s << p
        end
      }
    end # === def initialize

    # =============================================================================
    # Class
    # =============================================================================

    def self.to_value(t : Token)
      case
      when A_Number.looks_like?(t)
        A_Number.new(t)
      when Number_Unit.looks_like?(t)
        Number_Unit.new(t)
      when Color.looks_like?(t)
        Color.new(t)
      when Function_Call.looks_like?(t)
        Function_Call.new(t)
      when Keyword.looks_like?(t)
        Keyword.new(t)
      else
        raise CSS_Author_Error.new("Invalid string: #{t.summary}")
      end
    end # === def self.to_value

  end # === struct Property_Value_Splitter

end # === module DA_CSS
