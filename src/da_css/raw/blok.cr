
module DA_CSS

  struct Raw_Blok

    getter selector : A_Char_Deque
    getter propertys = Deque(Raw_Property).new

    def initialize(@selector)
    end # === def initialize

    def english_name
      "selector with block"
    end # === def english_name

    def push(x : Raw_Property)
      @propertys.push x
    end # === def push

    def print(p : Printer)
      p.raw! selector.to_s
      p.raw! " {\n"
      propertys.each { |prop|
        prop.print p
      }
      p.raw! "}\n"
    end # === def print

  end # === struct Raw_Blok

end # === module DA_CSS
