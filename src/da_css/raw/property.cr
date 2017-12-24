
module DA_CSS

  struct Raw_Property

    getter name : Token
    getter values : Deque(Token)

    def initialize(@name, @values)
    end # === def initialize

    def english_name
      "property"
    end # === def english_name

    def print(p : Printer)
      p.raw! name.to_s
      p.raw! ": "
      @values.each_with_index { |x, i|
        p.raw! ' ' if i != 0
        x.print p
      }
      p.raw! ";\n"
    end # === def print

  end # === struct Raw_Property

end # === module DA_CSS
