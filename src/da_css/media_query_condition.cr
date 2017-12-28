
module DA_CSS

  struct Media_Query_Condition

    @token : Token
    def initialize(@token : Token)
    end # === def initialize

    def to_tokens
      @token.split
    end

  end # === struct Media_Query_Condition

end # === module DA_CSS
