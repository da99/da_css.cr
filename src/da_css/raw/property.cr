
module DA_CSS

  struct Raw_Property

    getter name : Token
    getter value : Token

    def initialize(@name, raw_value : Token)
      @value = raw_value
    end # === def initialize

    def english_name
      "property"
    end # === def english_name

  end # === struct Raw_Property

end # === module DA_CSS
