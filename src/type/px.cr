
module Style

  struct Px

    def initialize(num : Int32)
      @val = num
    end # === def initialize

    def value
      "#{@val}px"
    end # === def value

  end # === class PX

end # === module Style
