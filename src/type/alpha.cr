
module Style

  struct Alpha

    @value : Int32

    def initialize(raw : Int32)
      if raw < 0.0 || raw > 1.0
        raise Exception.new("Invalid alpha value: #{raw.inspect}")
      end
      @value = raw
    end # === def initialize

    def value
      @value
    end # === def value

  end # === struct Alpha

end # === module Style
