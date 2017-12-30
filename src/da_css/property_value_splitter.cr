
module DA_CSS

  struct Property_Value_Splitter

    getter raw : Token
    # @values = Deque(Number | Number_Unit | Color | Function_Call | Keyword ).new
    getter tokens = Tokens.new

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
    end # === def initialize

  end # === struct Property_Value_Splitter

end # === module DA_CSS
