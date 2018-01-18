
module DA_CSS

  # Example:
  #   (max-width: 900px, min-width: 400px)
  #   (color)
  struct Media_Query_Condition

    @raw : Token
    @list = Deque(Media_Query_Keyword | Media_Query_Condition_Key_Value).new

    def initialize(@raw : Token)
      last = @raw.size - 1
      kv = @raw.split_with_splitter { |p, s|
        c = p.char
        case
        when c == OPEN_PAREN && s.index == 0
          next
        when c == CLOSE_PAREN && s.index == last
          next
        when c == COMMA
          s << s.consume_token if s.token?
        else
          s << p
        end
      }
      kv.each { |t|
        if t.any?(COLON)
          @list.push Media_Query_Condition_Key_Value.new(t)
        else
          @list.push Media_Query_Keyword.new(t)
        end
      }
    end # === def initialize

    def to_s(io)
      io << OPEN_PAREN
      @list.join(", ", io)
      io << CLOSE_PAREN
    end # === def to_s

  end # === struct Media_Query_Condition

end # === module DA_CSS
