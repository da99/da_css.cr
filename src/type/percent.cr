
module Style

  struct Percent

    include Positive_Negative

    def initialize(num : Int32)
      @val = num
    end # === def initialize

    def raw
      @val
    end

    def to_css
      "#{@val}%"
    end # === def value
  end # === class PX

  def percent(num)
    Percent.new(num)
  end

end # === module Style
