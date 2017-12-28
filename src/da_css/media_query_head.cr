
#     when 'a'..'z', '(', ')', ':', '_', '0'..'9', ',', '-'
module DA_CSS

  struct Media_Query_Head

    @raw : Token
    def initialize(@raw)
    end # === def initialize

    def to_tokens
      stack = Deque(Media_Query_Keyword | Media_Query_Condition).new
      @raw.split_with_splitter { |position, s|
        c = position.char
        case
        when c.whitespace?
          if s.token?
            stack << Media_Query_Keyword.new(s.consume_token)
          end

        when c == OPEN_PAREN
          s.save if s.token?
          stack << Media_Query_Condition.new(s.reader.consume_through(CLOSE_PAREN))
        else
          s << position
        end
      }.each { |t| stack << Media_Query_Keyword.new(t) }
      tokens = Tokens.new
      stack.each { |x|
        case x
        when Media_Query_Keyword
          tokens << x.to_token
        else
          x.to_tokens.each { |t| tokens << t }
        end
      }
      tokens
    end # === def to_tokens

  end # === struct Media_Query_Head

end # === module DA_CSS
