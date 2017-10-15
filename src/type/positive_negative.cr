
module DA_STYLE

  module Positive_Negative

    def positive!
      if (raw < 0)
        raise Exception.new("value can only be positive: #{self.inspect}")
      end
      return self
    end

    def negative!
      if (raw > 0)
        raise Exception.new("value can only be negative: #{self.inspect}")
      end
      return self
    end

  end # === module Positive_Negative

end # === module DA_STYLE
