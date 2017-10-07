
module Style

  struct HSLA_Color

    @first  : Int32
    @second : Percent
    @third  : Percent
    @alpha  : Float64

    def initialize(first, @second, @third, alpha)
      @first  = Hue.new(first)
      @alpha  = Alpha.new(alpha)
    end # === def initialize

  end # === struct HSLA_Color

end # === module Style
