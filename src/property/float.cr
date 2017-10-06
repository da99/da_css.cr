
module Style

  def float(dir : String)
    case
    when "left", "right", "none", "inline-start", "inline-end", "inherit", "initial", "unset"
      @content << " float: #{dir}; "
    else
      raise Exception.new("Invalid float value: #{dir.inspect}")
    end
  end # === def float

end # === module Style
