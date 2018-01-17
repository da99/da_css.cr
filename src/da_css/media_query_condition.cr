
module DA_CSS

  struct Media_Query_Condition

    @raw : Token
    @list = Deque(Media_Query_Condition_Key_Value).new

    def initialize(@raw : Token)
      kv = @raw.split_with_splitter { |p, s|
        c = p.char
        if c == COMMA
          s << s.consume_token if s.token?
        else
          s << p
        end
      }
      kv.each { |t|
        @list.push Media_Query_Condition_Key_Value.new(t)
      }
    end # === def initialize

    def to_s(io)
      @list.join(',', io)
    end # === def to_s

  end # === struct Media_Query_Condition

end # === module DA_CSS
