
module DA_STYLE

  struct RGBA_Color

    @first  : Int32
    @second : Int32
    @third  : Int32
    @alpha  : Alpha

    def initialize(@first, @second, @third, @alpha : Alpha)
    end # === def initialize

    def initialize(@first, @second, @third, alpha)
      @alpha  = Alpha.new(alpha)
    end # === def initialize

    def write_to(io)
      io.raw! "rgba(", @first, ",", @second, ",", @third, @alpha.to_css, ")"
    end # === def value

  end # === struct RGBA_Color

  def rgba(*args)
    RGBA_Color.new(*args)
  end # === def rgb

end # === module DA_STYLE
