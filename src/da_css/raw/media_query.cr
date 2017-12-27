
module DA_CSS

  struct Raw_Media_Query

    getter head : Token
    getter body = Deque(Raw_Blok).new

    def initialize(@head)
    end # === def initialize

    def english_name
      "media query"
    end # === def english_name

    def push(x : Raw_Blok)
      body.push x
    end # === def push

    def to_s(io)
      io << "@"
      head.each_with_index { |x, i|
        io << SPACE if !i.zero?
        x.to_s io
      }
      io << " {\n"
      body.each { |blok|
        blok.to_s io
      }
      io << "}\n"
    end # === def print

  end # === struct Raw_Media_Query

end # === module DA_CSS

