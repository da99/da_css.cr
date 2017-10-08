
module Style

  struct Px

    include Positive_Negative

    def initialize(num : Int32)
      @val = num
    end # === def initialize

    def raw
      @val
    end # === def raw

    def to_css
      "#{@val}px"
    end # === def value

  end # === class PX

  def px(num)
    Px.new(num)
  end # === def px

end # === module Style
