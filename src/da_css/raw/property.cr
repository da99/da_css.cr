
module DA_CSS

  struct Raw_Property

    getter name : Token
    getter values : Deque(Token)

    def initialize(@name, @values)
    end # === def initialize

    def english_name
      "property"
    end # === def english_name

    def to_s(io)
      io << name.to_s << ": "
      @values.each_with_index { |x, i|
        io << SPACE if !i.zero?
        x.to_s io
      }
      io << ";\n"
    end # === def print

  end # === struct Raw_Property

end # === module DA_CSS
