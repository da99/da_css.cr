
module Style

  struct Angle_Degree

    def initialize(raw : Int32)
      if raw < 0 || raw > 360
        raise Exception.new("Invalid value for angle degree: #{raw.inspect}")
      end
      @val = raw
    end # === def initialize

    def to_css
      "#{@val}deg"
    end # === def to_css

  end # === struct Angle_Degree

  def deg(num)
    if num == 0
      Zero.new
    else
      Angle_Degree.new(num)
    end
  end # === def deg

end # === module Style
