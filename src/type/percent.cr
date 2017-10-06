
module Style

  struct Percent
    def initialize(num : Int32)
      @val = num
    end # === def initialize

    def value
      "#{@val}%"
    end # === def value
  end # === class PX

end # === module Style
