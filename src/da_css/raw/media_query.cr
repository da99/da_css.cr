
module DA_CSS

  struct Raw_Media_Query

    getter selector : Deque(Position_Deque)
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
      p.raw! Position_Deque.join(selector)
      p.raw! " {\n"
      bloks.each { |blok|
        blok.print p
      }
      p.raw! "}\n"
    end # === def print

  end # === struct Raw_Media_Query

end # === module DA_CSS
