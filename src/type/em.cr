
module Style

  struct Em

    include Positive_Negative

    def initialize(num : Int32 | Float64)
      # if num < 0 || num > 10
      #   raise Exception.new("Value out of range for .em: #{num.inspect}")
      # end
      @val = num
    end # === def initialize

    def raw
      @val
    end # === def raw

    def to_css
      "#{@val}em"
    end # === def value

  end # === class PX

  def em(num)
    if num == 0
      Zero.new
    else
      Em.new(num)
    end
  end # === def em

end # === module Style
