
module DA_STYLE

  module HUE

    def hue(s)
      DA_STYLE::HUE::VALUE.new(s)
    end # === def hue

    struct VALUE

      @value : Int32

      def initialize(raw : Int32)
        if raw < 0 || raw > 360
          raise Exception.new("Invalid value for hue: #{raw.inspect}")
        end

        @value = raw
      end # === def initialize

      def raw
        @value
      end # === def raw

      def to_css
        @value.to_s
      end

    end # === struct Hue
  end # === module HUE

end # === module DA_STYLE
