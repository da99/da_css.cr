
module Style

  struct RGBA_Color

    @first  : RGB_Level
    @second : RGB_Level
    @third  : RGB_Level
    @alpha  : Alpha

    def initialize(@first : RGB_Level, @second : RGB_Level, @third : RGB_Level, @alpha : Alpha)
    end # === def initialize

    def initialize(first, second, third, alpha)
      @first  = RGB_Level.new(first)
      @second = RGB_Level.new(second)
      @third  = RGB_Level.new(third)
      @alpha  = Alpha.new(alpha)
    end # === def initialize

    def to_css
      "rgba(#{@first.to_css}, #{@second.to_css}, #{@third.to_css}, #{@alpha.to_css})"
    end # === def value

  end # === struct RGBA_Color

  def rgba(*args)
    RGBA_Color.new(*args)
  end # === def rgb

end # === module Style
