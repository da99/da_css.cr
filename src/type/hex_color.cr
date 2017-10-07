
module Style

  struct Hex_Color

    def initialize(val : String)
      if !val.match(/^#[a-zA-Z0-9]{6}([a-zA-Z0-9]{2})?$/)
        raise Exception.new("Invalid color: #{val.inspect}")
      end

      @val = val
    end # === def initialize

    def value
      @val
    end # === def value

  end # === class Color

end # === module Style
