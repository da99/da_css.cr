
module Style

  def padding(px : Px | Percent | Em)
    @io << " padding: " << px.to_css << ";"
  end # === def padding

end # === module Style
