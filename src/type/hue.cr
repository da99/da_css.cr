
module Style

  struct Hue

    @value : Int32

    def initialize(raw : Int32)
      if raw < 0 || raw > 360
        raise Exception.new("Invalid value for hue: #{raw.inspect}")
      end

      @value = raw
    end # === def initialize

    def raw
      @value
    end # === def raw

    def value
      @value
    end # === def value

  end # === struct Hue

end # === module Style
