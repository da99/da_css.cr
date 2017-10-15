
module DA_STYLE

  module RGB

    def rgb(*args)
      DA_STYLE::RGB::VALUE.new(*args)
    end # === def rgb

    struct VALUE

      @first  : Int32
      @second : Int32
      @third  : Int32

      def initialize(@first, @second, @third)
      end # === def initialize

      def write_to(io)
        io.raw! "rgb(", @first, ",", @second, ",", @third, ")"
      end

    end # === struct RGB_Color

  end # === module RGB

end # === module DA_STYLE
