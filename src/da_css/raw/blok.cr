
module DA_CSS

  struct Raw_Blok

    getter selector : A_Char_Deque
    getter propertys = Deque(Raw_Property).new

    def initialize(@selector)
    end # === def initialize

  end # === struct Raw_Blok

end # === module DA_CSS
