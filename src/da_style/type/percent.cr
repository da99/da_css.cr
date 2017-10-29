
module DA_STYLE

  module PERCENT

    def percent(i)
      DA_STYLE::PERCENT::VALUE.new(i)
    end # === def percent

    struct VALUE

      include Positive_Negative

      def initialize(num : Int32)
        @val = num
      end # === def initialize

      def raw
        @val
      end

      def write_to(io)
        io.raw! @val, "%"
      end # === def value
    end # === class PX

  end # === module PERCENT

end # === module DA_STYLE
