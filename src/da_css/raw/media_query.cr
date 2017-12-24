
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

    def print(p : Printer)
      p.raw! "@"
      selector.each_with_index { |x, i|
        p.raw! ' ' if i != 0
        x.print p
      }
      p.raw! " {\n"
      bloks.each { |blok|
        blok.print p
      }
      p.raw! "}\n"
    end # === def print

  end # === struct Raw_Media_Query

end # === module DA_CSS
