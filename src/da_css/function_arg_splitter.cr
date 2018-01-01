
module DA_CSS

  struct Function_Arg_Splitter

    getter raw : Token
    getter args : Deque(A_String) = Deque(A_String).new

    def initialize(@raw)
      args_as_tokens = @raw.split_with_splitter { |position, s|
        c = position.char
        case
        when (c == OPEN_PAREN && s.first?) || (c == CLOSE_PAREN && s.last?)
          :ignore
        when c == ','
          s.save if s.token?
        else
          s << position
        end
      }
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
