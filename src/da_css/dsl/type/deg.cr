
module DA_CSS

  module DEG

    def deg(num)
      if num == 0
        Zero.new
      else
        DA_CSS::DEG::VALUE.new(num)
      end
    end # === def deg

    struct VALUE

      def initialize(raw : Int32)
        if raw < 0 || raw > 360
          raise Exception.new("Invalid value for angle degree: #{raw.inspect}")
        end
        @val = raw
      end # === def initialize

      def write_to(io)
        io.raw! @val, "deg"
      end # === def to_css

    end # === struct Angle_Degree

  end # === module DEG

end # === module DA_CSS
