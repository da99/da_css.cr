
module DA_STYLE

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

    def to_css
      @value.to_s
    end

  end # === struct Hue

end # === module DA_STYLE
