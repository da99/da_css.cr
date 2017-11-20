
module Node

  struct Statement

    getter raw : Codepoints::Array
    def initialize(@raw)
    end # === def initialize

    def to_s
      @raw.to_s
    end # === def to_s

    def to_s(io_css : IO_CSS)
      @raw.each_with_index { |codepoints, i|
        io_css.raw! ' ' if i != 0
        codepoints.each { |x|
          io_css.raw! x.chr
        }
      }
      self
    end # === def to_s

  end # === struct Statement

end # === module Node