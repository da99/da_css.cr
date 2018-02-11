
module DA_CSS

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
        n = peek unless last?
        case

        when c == '/' && n && n.char.whitespace?
          if !t.empty?
            @values.push self.class.to_value(t)
            t = Token.new
          end
          st = Token.new
          st.push position
          @values.push Slash.new(st)

        when c == ','
          if !t.empty?
            @values.push self.class.to_value(t)
            t = Token.new
          end
          ct = Token.new()
          ct.push position
          @values.push self.class.to_value(ct)

        when c.whitespace?
          if !t.empty?
            @values.push self.class.to_value(t)
            t = Token.new
          end

        when last?
          t.push(position) 
          @values.push self.class.to_value(t)
          t = Token.new

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
      when Number_Units_Slashed.looks_like?(t)
        Number_Units_Slashed.new(t)

      when A_String.looks_like?(t)
        A_String.new(t)

      when A_Number.looks_like?(t)
        A_Number.new(t)

      when Number_Unit.looks_like?(t)
        Number_Unit.new(t)

      when Percentage.looks_like?(t)
        Percentage.new(t)

      when Color.looks_like?(t)
        Color.new(t)

      when Function_Call.looks_like?(t)
        Function_Call.new(t)

      when Comma.looks_like?(t)
        Comma.new(t)

      else
        begin
          return Keyword.new(t)
        rescue e : CSS_Author_Error
          begin
            return Color_Keyword.new(t)
          rescue e2 : CSS_Author_Error
            :continue
          end
        end

        raise CSS_Author_Error.new("Invalid string: #{t.summary}")
      end
    end # === def self.to_value

  end # === struct Property_Value_Splitter

end # === module DA_CSS
