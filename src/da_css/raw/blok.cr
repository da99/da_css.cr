
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

    def to_s(io)
      selector.each_with_index do |x, i|
        io << SPACE if !i.zero?
        x.to_s io
      end
      io << " {\n"
      propertys.each { |prop|
        prop.to_s io
      }
      io <<  "}\n"
    end # === def print

  end # === struct Raw_Blok

end # === module DA_CSS
