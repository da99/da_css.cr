
module DA_CSS

  struct Line

    getter number  : Int32
    getter content : String
    getter parent  : Parser

    def initialize(css_char : CSS_Char)
      pos       = css_char.pos
      @parent   = css_char.parent
      @number   = 0
      @content  = ""
      start_pos = 0
      end_pos   = 0
      @parent.origin_string.each_line { |l|
        end_pos += (l.size - 1)
        if start_pos <= pos <= current_pos
          @content = l
        end
        @number += 1
      }

    end # === def initialize

    def number
    end # === def line_number


  end # === struct Line

end # === module DA_CSS
