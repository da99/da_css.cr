
module DA_CSS

  struct Line

    getter number  : Int32
    getter content : String
    getter parent  : Origin

    def initialize(a_char : A_Char)
      pos       = a_char.pos
      @parent   = a_char.origin
      @number   = 0
      @content  = ""
      start_pos = 0
      end_pos   = 0
      @parent.string.each_line { |l|
        end_pos += (l.size - 1)
        if start_pos <= pos
          @content = l
        end
        @number += 1
      }

    end # === def initialize

    def number
    end # === def line_number


  end # === struct Line

end # === module DA_CSS
