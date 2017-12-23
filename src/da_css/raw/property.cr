
module DA_CSS

  struct Raw_Property

    getter name : A_Char_Deque
    getter values : Deque(A_Char_Deque)

    def initialize(@name, @values)
    end # === def initialize

    def english_name
      "property"
    end # === def english_name

    def print(p : Printer)
      p.raw! name.to_s
      p.raw! ": "
      p.raw! A_Char_Deque.join(@values)
      p.raw! ";\n"
    end # === def print

  end # === struct Raw_Property

end # === module DA_CSS
