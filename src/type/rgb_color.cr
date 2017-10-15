
module DA_STYLE

  struct RGB_Color

    @first  : Int32
    @second : Int32
    @third  : Int32

    def initialize(@first, @second, @third)
    end # === def initialize

    def write_to(io)
      io.raw! "rgb(", @first, ",", @second, ",", @third, ")"
    end

  end # === struct RGB_Color

  def rgb(*args)
    RGB_Color.new(*args)
  end # === def rgb

end # === module DA_STYLE
