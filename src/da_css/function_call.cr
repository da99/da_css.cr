
module DA_CSS

  struct Function_Call

    # =============================================================================
    # Instance
    # =============================================================================

    getter name : Token = Token.new
    getter args : Deque(A_String)

    def initialize(@name, raw_args : Token)
      @args = Function_Arg_Splitter.new(raw_args).args
    end # === def initialize

    def initialize(raw : Token)
      capture_name = true
      raw_args = Token.new
      raw.each { |position|
        c = position.char
        case
        when !capture_name || (args.empty? && c == OPEN_PAREN)
          capture_name = false
          raw_args.push position
        else
          @name.push position
        end
      }
      @args = Function_Arg_Splitter.new(raw_args).args
    end # === def initialize

    def inspect(io)
      io << "Function_Call["
      io << "name: "
      name.inspect(io)
      io << " args: "
      args.each_with_index { |a, i|
        io << ", " if !i.zero?
        a.inspect(io)
      }
      io << "]"
      io
    end # === def inspect

    def to_s(io)
      name.to_s(io)
      io << "("
      args.join(", ", io)
      io << ")"
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      t.last == ')'
    end # === def looks_like?

  end # === struct Function_Call

end # === module DA_CSS
