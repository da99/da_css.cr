
module Style

  def background(color : Color | String)
    case color
    when String
      color = Color.new(color)
    end
    @content << " background: " << color.value << ";"

    return self
  end

end # === module Style
