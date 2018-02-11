
module DA_CSS

  struct Function_Arg_Splitter

    getter token : Token
    getter args = FUNCTION_ARGS.new

    def initialize(@token)
      args_as_tokens = Deque(Token).new
      token = Token.new
      @token.each_with_reader { |current, reader|
        c = current.char
        case
        when (c == OPEN_PAREN && reader.first?) || (c == CLOSE_PAREN && reader.last?)
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
        when A_Number.looks_like?(t)
          @args << A_Number.new(t)
        when Percentage.looks_like?(t)
          @args << Percentage.new(t)
        when Number_Unit.looks_like?(t)
          @args << Number_Unit.new(t)
        else
          raise CSS_Author_Error.new("Invalid function argument: #{t.summary}")
        end
      }
    end # === def initialize

  end # === struct Function_Arg_Splitter

end # === module DA_CSS
