
module Style

  struct Color

    def initialize(val : String)
      if !val.match(/^#[a-zA-Z0-9]+$/)
        raise Exception.new("Invalid color: #{val}")
      end

      @val = val
    end # === def initialize

    def value
      @val
    end # === def value

  end # === class Color

end # === module Style
