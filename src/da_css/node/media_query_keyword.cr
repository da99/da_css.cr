
module DA_CSS

  module Node

    struct Media_Query_Keyword

      @raw : Position_Deque
      @name : String
      def initialize(@raw)
        @name = @raw.to_s
        case @name
        when "screen", "and", "not", "all", "monochrome", "color", "print"
          :ok
        else
          raise Invalid_Keyword.new("Unknown keyword: #{@name.inspect}")
        end
      end

      def print(p : Printer)
        p.raw! @name
      end # === def print(

    end # === struct Media_Query_Keyword

  end # === module Node

end # === module DA_CSS
