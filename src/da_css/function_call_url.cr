
module DA_CSS

  struct Function_Call_URL

    # =============================================================================
    # Instance
    # =============================================================================

    @raw : Function_Call
    @args : A_String
    delegate to_token, to: @raw

    def initialize(@raw)
      @args = A_String.new
    end # === def initialize

    # =============================================================================
    # Class
    # =============================================================================

  end # === struct Function_Call

end # === module DA_CSS
