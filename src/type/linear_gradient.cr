
module Style

  struct Linear_Gradient

    KEY = "linear-gradient"

    def initialize(angle : Angle_Degree, c1 : Color, c2 : Color)
      @value = "#{key}(#{Style.join(angle, c1, c2)})"
    end # === def initialize

    def initialize(angle : Angle_Degree, c1 : Color, c2 : Color)
      @value = "#{key}(#{Style.join(angle, c1, c2)})"
    end # === def initialize

    def initialize(*args)
      args.each { |x|
      case args
      when String
        unless x.match(/^[a-zA-Z\ \-\%\_\#]$/)
          raise Exception.new("Invalid value for gradient: #{x.inspect}")
        end
        x
      when Angle_Degree, Color
        x
      else
        raise Exception.new("Invalid value for gradient: #{x.inspect}")
      end
      }

      @value = "#{key}(#{Style.join(*args)})"
    end # === def initialize

    def to_css
      @value
    end # === def to_css

  end # === struct Linear_Gradient

end # === module Style
