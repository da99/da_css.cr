
module DA_CSS

  struct Line

    getter num     : Int32
    getter content : String

    def initialize(p : Position)
      pos_num   = p.num
      @content  = ""
      num = 0
      counter = 0
      p.origin.each_char { |c|
        case c
        when NEW_LINE
          num += 1
        end
        counter += 1
        break if counter >= pos_num
      }
      @num = num
    end # === def initialize

    def number
      @num + 1
    end

  end # === struct Line

end # === module DA_CSS
