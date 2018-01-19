
module DA_CSS

  struct Media_Query_Head

    @raw : Token
    @lists = Deque(Media_Query_List).new

    def initialize(@raw)
      tokens = @raw.split_with_splitter { |p, s|
        c = p.char
        case
        when c == 'm' && s.index == 0,
             c == 'e' && s.index == 1,
             c == 'd' && s.index == 2,
             c == 'i' && s.index == 3,
             c == 'a' && s.index == 4
          next
        when c == COMMA
          if s.token?
            @lists.push Media_Query_List.new(s.consume_token)
          end
        when c == OPEN_PAREN
          s << s.consume_through(OPEN_PAREN, CLOSE_PAREN)
        else
          s << p
        end
      }

      t = tokens.first?
      if t
        raise CSS_Author_Error.new("Unknown value: #{t.summary}")
      end
    end # === def initialize

    def inspect(io)
      io << self.class.name << "["
      @raw.inspect(io)
      io << "]"
    end # === def to_tokens

    def to_s(io)
      io << "@media "
      @lists.join(", ", io)
      io << SPACE
    end # === def to_s

  end # === struct Media_Query_Head

end # === module DA_CSS
