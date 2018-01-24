
module DA_CSS

  struct Function_Call_RGBA

    # =============================================================================
    # Instance
    # =============================================================================

    @args : Deque(A_String)

    def initialize(name : Token, @args)
    end # === def initialize

    def to_s(io)
      io << "rgba" << OPEN_PAREN
      @args.join(", ", io)
      io << CLOSE_PAREN
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

  end # === struct Function_Call

end # === module DA_CSS
