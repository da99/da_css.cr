
module DA_STYLE

  struct Alpha

    @value : Int32

    def initialize(raw : Int32)
      if raw < 0.0 || raw > 1.0
        raise Exception.new("Invalid alpha value: #{raw.inspect}")
      end
      @value = raw
    end # === def initialize

    def to_css
      @value
    end

    def write_to(io)
      io.raw! @value
    end # === def value

  end # === struct Alpha

end # === module DA_STYLE
