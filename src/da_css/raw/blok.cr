
module DA_CSS

  struct Raw_Blok

    getter selector : Deque(Token)
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
      selector.each_with_index do |x, i|
        p.raw!(' ') if i != 0
        x.print p
      end
      p.raw! " {\n"
      propertys.each { |prop|
        prop.print p
      }
      p.raw! "}\n"
    end # === def print

  end # === struct Raw_Blok

end # === module DA_CSS
