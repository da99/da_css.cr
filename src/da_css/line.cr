
module DA_CSS

  struct Line

    getter num     : Int32
    getter content : String

    def initialize(p : Position)
      pos_num   = p.num
      o         = p.origin
      @num      = 0
      @content  = ""
      start_pos = 0
      end_pos   = 0
      o.raw.each_line { |l|
        end_pos += (l.size - 1)
        if start_pos <= pos_num
          @content = l
        end
        @num += 1
      }
    end # === def initialize

    def number
      @num + 1
    end

  end # === struct Line

end # === module DA_CSS
