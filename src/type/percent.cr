
module Style

  struct Percent
    def initialize(num : Int32)
      if num > 100 || num < 0
        raise Exception.new("Invalid value for percent: #{num.inspect}")
      end

      @val = num
    end # === def initialize

    def raw
      @val
    end

    def value
      "#{@val}%"
    end # === def value
  end # === class PX

end # === module Style
