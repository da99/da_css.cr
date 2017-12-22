
module DA_CSS

  struct Raw_Property

    getter name : A_Char_Deque
    getter values : A_Char_Deque

    def initialize(@name, @values)
    end # === def initialize

  end # === struct Raw_Property

end # === module DA_CSS
