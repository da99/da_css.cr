
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

end # === class Int32
