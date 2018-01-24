
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
      t = Token.new
      @raw.reader {
        position = current
        c = position.char
        case
        when c.whitespace? || last?
          if !t.empty?
            t.push(position) unless c.whitespace?
            @values.push self.class.to_value(t)
            t = Token.new
          end

        when c == OPEN_PAREN
          if t.empty?
            raise CSS_Author_Error.new("Missing function call name at #{position.summary}")
          end
          @values.push Function_Call.new(consume_through(CLOSE_PAREN, t))
          t = Token.new

        else
          t.push position
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
