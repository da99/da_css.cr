
module DA_CSS

  struct Column

    getter line   : Line
    getter num    : Int32

    def initialize(p : Position)
      @line = p.line
      target = p.num
      counter = 0
      num = 0
      p.origin.each_char { |c|
        break if counter == target
        case c
        when NEW_LINE
          num = 0
        else
          num += 1
        end
        counter += 1
      }
      @num = num
    end # === def initialize

    def number
      @num + 1
    end # === def number

  end # === struct Column

end # === module DA_CSS
