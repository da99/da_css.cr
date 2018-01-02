
module DA_CSS

  struct Media_Query_List

    @raw : Token
    @values = Deque(Media_Query_Keyword | Media_Query_Condition).new

    def initialize(@raw)
      invalid = @raw.split_with_splitter {  |p, s|
        c = p.char
        case
        when c.whitespace?
          if token?
            @values.push Media_Query_Keyword.new(s.consume_token)
          end

        when c == OPEN_PAREN && !s.token?
          t = s.consume_through(OPEN_PAREN, CLOSE_PAREN)
          @values.push Media_Query_Condition.new(t)

        else
          s << p
        end

      }

      t = invalid.first?
      if t
        raise CSS_Author_Error.new("Invalid value: #{t.summary}")
      end
    end # === def initialize

    def inspect(io)
      io << self.class.name << "["
      @raw.inspect(io)
      io << "]"
    end # === def inspect

    def to_s(io)
      @values.join(SPACE, io)
    end # === def to_s

  end # === struct Media_Query_List

end # === module DA_CSS
