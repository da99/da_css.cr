
module DA_CSS

  struct Media_Query_Keyword

    getter token : Token

    def initialize(@token)
      str = @token.to_s
      case str
      when "only", "media", "and", "or", ",", "screen", "not", "all", "monochrome", "color", "print",
        "hover", "landscape"
        :accepted
      else
        raise CSS_Author_Error.new("Invalid word for media query: #{str.inspect} @ #{@token.summary}")
      end
    end # === def initialize

    def comma?
      @token.size == 1 && @token.first.char == ','
    end # === def comma?

    def to_token
      @token
    end # === def to_token

    def to_s(io)
      @token.to_s(io)
    end # === def to_s

  end # === struct Media_Query_Keyword

end # === module DA_CSS
