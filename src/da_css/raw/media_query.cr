
module DA_CSS

  struct Raw_Media_Query

    getter selector : A_Char_Deque
    getter bloks = Deque(Raw_Blok).new

    def initialize(@selector)
    end # === def initialize

    def english_name
      "media query"
    end # === def english_name

    def print(p : Printer)
      p.raw! "@"
      p.raw! selector.to_s
      p.raw! " {\n"
      bloks.each { |blok|
        blok.print p
      }
      p.raw! "}\n"
    end # === def print

  end # === struct Raw_Media_Query

end # === module DA_CSS
