
module DA_CSS

  module HSLA

    def hsla(s)
      DA_CSS::HSLA::VALUE.new(s)
    end # === def hsla

    struct VALUE

      @first  : DA_CSS::HUE::VALUE
      @second : DA_CSS::PERCENT::VALUE
      @third  : DA_CSS::PERCENT::VALUE
      @alpha  : DA_CSS::ALPHA::VALUE

      def initialize(@first, @second, @third, @alpha)
      end # === def initialize

      def initialize(first, @second, @third, alpha)
        @first  = DA_CSS::HUE::VALUE.new(first)
        @alpha  = DA_CSS::ALPHA::VALUE.new(alpha)
      end # === def initialize

    end # === struct HSLA_Color


  end # === module HSLA

end # === module DA_CSS
