
module DA_STYLE

  struct HSLA_Color

    @first  : Hue
    @second : Percent
    @third  : Percent
    @alpha  : Alpha

    def initialize(@first, @second, @third, @alpha)
    end # === def initialize

    def initialize(first, @second, @third, alpha)
      @first  = Hue.new(first)
      @alpha  = Alpha.new(alpha)
    end # === def initialize

  end # === struct HSLA_Color

  def hsla(*args)
    HSLA_Color.new(*args)
  end # === def hsla

end # === module DA_STYLE
