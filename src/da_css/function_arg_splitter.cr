
module DA_CSS

  struct Function_Arg_Splitter

    getter raw : Token
    getter args : Deque(A_String) = Deque(A_String).new

    def initialize(@raw)
      args_as_tokens = Deque(Token).new
      token = Token.new
      @raw.reader {
        c = current.char
        case
        when (c == OPEN_PAREN && first?) || (c == CLOSE_PAREN && last?)
          :ignore
        when c == ','
          if !token.empty?
            args_as_tokens.push token
            token = Token.new
          end
        else
          token.push current
        end
      }
      args_as_tokens.push(token) unless token.empty?

      args_as_tokens.each { |t|
        case
        when A_String.looks_like?(t)
          @args << A_String.new(t)
        else
          raise CSS_Author_Error.new("Invalid function argument: #{t.summary}")
        end
      }
    end # === def initialize

  end # === struct Function_Arg_Splitter

end # === module DA_CSS