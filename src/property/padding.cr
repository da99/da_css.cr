
module Style

  def padding(px : Zero | Px | Percent | Em)
    write("padding", px)
  end # === def padding

end # === module Style
