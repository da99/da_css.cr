
module DA_STYLE

  struct RGB_Level

    @val : Int32
    def initialize(raw : Int32)
      if raw < 0 || raw > 255
        raise Exception.new("Invalid value for RGB level: #{raw.inspect}")
      end

      @val = raw
    end # === def initialize

    def raw
      @val
    end # === def raw

    def write_to(io)
      io.raw! @val
    end

  end # === struct RGB_Level

end # === module DA_STYLE
