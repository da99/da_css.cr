
module Style

  def width(quantity : Px | Em | Percent)
    @io << " width: #{quantity.to_css}; "
  end # === def width

end # === module Style
