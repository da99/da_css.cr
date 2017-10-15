
module DA_STYLE

  module HSLA

    def hsla(s)
      DA_STYLE::HSLA::VALUE.new(s)
    end # === def hsla

    struct VALUE

      @first  : DA_STYLE::HUE::VALUE
      @second : DA_STYLE::PERCENT::VALUE
      @third  : DA_STYLE::PERCENT::VALUE
      @alpha  : DA_STYLE::ALPHA::VALUE

      def initialize(@first, @second, @third, @alpha)
      end # === def initialize

      def initialize(first, @second, @third, alpha)
        @first  = DA_STYLE::HUE::VALUE.new(first)
        @alpha  = DA_STYLE::ALPHA::VALUE.new(alpha)
      end # === def initialize

    end # === struct HSLA_Color


  end # === module HSLA

end # === module DA_STYLE
