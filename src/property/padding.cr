
module Style

  def padding(px : Px | Percent | Em)
    @content << " padding: " << px.value << ";"
  end # === def padding

end # === module Style
