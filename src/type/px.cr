
module DA_STYLE

  module PX

    def px(v)
      Px.new(v)
    end # === def px

  end # === module PX

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

end # === module DA_STYLE
