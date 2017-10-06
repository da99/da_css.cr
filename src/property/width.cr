
module Style

  def width(quantity : Px | Em | Percent)
    @content << " width: #{quantity.value}; "
  end # === def width

end # === module Style
