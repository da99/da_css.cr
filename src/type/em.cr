
module Style

  struct Em
    def initialize(num : Int32 | Float64)
      if num < 0 || num > 10
        raise Exception.new("Value out of range for .em: #{num.inspect}")
      end
      @val = num
    end # === def initialize

    def value
      "#{@val}em"
    end # === def value
  end # === class PX

end # === module Style
