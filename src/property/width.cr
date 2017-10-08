
module Style

  def width(quantity : Zero | Px | Em | Percent)
    write("width", quantity)
  end # === def width

end # === module Style
