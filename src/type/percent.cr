
module DA_STYLE

  module PERCENT

    def percent(i)
      Percent.new(i)
    end # === def percent

  end # === module PERCENT

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

end # === module DA_STYLE
