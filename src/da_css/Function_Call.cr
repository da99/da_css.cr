
module DA_CSS

  struct Function_Call

    # =============================================================================
    # Instance
    # =============================================================================

    getter name : String
    getter args = FUNCTION_ARGS.new

    def initialize(raw : Token)
      name_token = Token.new
      capture_name = true
      raw_args = Token.new
      raw.each { |position|
        c = position.char
        case
        when !capture_name || (args.empty? && c == OPEN_PAREN)
          capture_name = false
          raw_args.push position
        else
          name_token.push position
        end
      }

      @args = Function_Arg_Splitter.new(raw_args).args
      @name = name_token.to_s.downcase
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
      io << @name << OPEN_PAREN
      @args.join(", ", io)
      io << CLOSE_PAREN
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      t.last == ')'
    end # === def looks_like?

  end # === struct Function_Call

end # === module DA_CSS
