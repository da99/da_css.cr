
module DA_CSS

  struct Raw_Media_Query

    getter selector : A_Char_Deque
    getter bloks = Deque(Raw_Block).new

    def initialize(@selector)
    end # === def initialize

  end # === struct Raw_Media_Query

end # === module DA_CSS
