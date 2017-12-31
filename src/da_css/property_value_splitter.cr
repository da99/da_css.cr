
module DA_CSS

  struct Property_Value_Splitter

    getter raw : Token
    getter tokens = Tokens.new
    getter values = Deque(Number | Number_Unit | Color | Function_Call | Keyword ).new

    def initialize(@raw)
      @tokens = @raw.split_with_splitter { |p, s|
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
          arg = s.consume_through(CLOSE_PAREN)
          s.tokens << Function_Call.new(name, arg).to_token

        else
          s << p
        end
      }

      @tokens.each { |t|
        v = case
            when Number.looks_like?(t)
              Number.new(t)
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
        @values.push v
      }
    end # === def initialize

  end # === struct Property_Value_Splitter

end # === module DA_CSS
