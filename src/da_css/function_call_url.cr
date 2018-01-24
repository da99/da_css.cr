
module DA_CSS

  struct Function_Call_URL

    # =============================================================================
    # Instance
    # =============================================================================

    @arg : A_String
    delegate to_token, to: @raw

    def initialize(name : Token, args)
      a = args.first?
      @arg = case a
             when A_String
               a
             when Nil
               raise CSS_Author_Error.new("No args specified for: #{name.summary}")
             else
               raise CSS_Author_Error.new("Invalid args for, #{name.summary}: #{a.to_s.inspect}")
             end
    end # === def initialize

    def to_s(io)
      io << "url" << OPEN_PAREN
      @arg.to_s(io)
      io << CLOSE_PAREN
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

  end # === struct Function_Call

end # === module DA_CSS
