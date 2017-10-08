
struct Int32

  def percent
    Style::Percent.new(self)
  end

  def px
    Style::Px.new(self)
  end # === def px

  def em
    Style::Em.new(self)
  end

  def deg
    Style::Angle_Degree.new(self)
  end # === def deg

  def to_css
    return "0" if self == 0
    raise Exception.new("Invalid value for length: #{self.inspect}")
  end # === def to_css

end # === class Int32
