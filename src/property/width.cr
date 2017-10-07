
module Style

  def width(quantity : Px | Em | Percent)
    @content << " width: #{quantity.to_css}; "
  end # === def width

end # === module Style
