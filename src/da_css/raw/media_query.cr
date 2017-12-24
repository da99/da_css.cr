
module DA_CSS

  struct Raw_Media_Query

    getter selector : Deque(Token)
    getter bloks = Deque(Raw_Blok).new

    def initialize(@selector)
    end # === def initialize

    def english_name
      "media query"
    end # === def english_name

    def push(x : Raw_Blok)
      bloks.push x
    end # === def push

    def to_s(io)
      io << "@"
      selector.each_with_index { |x, i|
        io << SPACE if !i.zero?
        x.to_s io
      }
      io << " {\n"
      bloks.each { |blok|
        blok.to_s io
      }
      io << "}\n"
    end # === def print

  end # === struct Raw_Media_Query

end # === module DA_CSS
