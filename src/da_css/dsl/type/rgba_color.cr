
module DA_CSS

  module RGBA

    def rgba(*args)
      DA_CSS::RGBA::VALUE.new(*args)
    end # === def rgb

    struct VALUE

      @first  : Int32
      @second : Int32
      @third  : Int32
      @alpha  : DA_CSS::ALPHA::VALUE

      def initialize(@first, @second, @third, @alpha)
      end # === def initialize

      def initialize(@first, @second, @third, alpha)
        @alpha  = DA_CSS::ALPHA::VALUE.new(alpha)
      end # === def initialize

      def write_to(io)
        io.raw! "rgba(", @first, ",", @second, ",", @third, @alpha.to_css, ")"
      end # === def value

    end # === struct RGBA_Color

  end # === module RGBA

end # === module DA_CSS
