
module Style

  def padding(px : Px | Percent | Em)
    @content << " padding: " << px.to_css << ";"
  end # === def padding

end # === module Style
