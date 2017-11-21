
module DA_CSS

  module Node

    struct Size

      @raw : String
      def initialize(raw)
        num = IO::Memory.new
        unit = IO::Memory.new
        period_count = 0
        last_code = nil
        raw.each_with_index { |x, pos|
          case
          when x == '-'.hash && pos == 0
            num << x.chr

          when x == '.'.hash
            period_count += 1
            num << x.chr

          when (('0'.hash)..('9'.hash)).includes?(x) || x == '.'.hash || x == '-'.hash
            num << x.chr

          when (('a'.hash)..('z'.hash)).includes?(x)
            unit << x.chr

          else
            raise Invalid_Char.new(x, "Invalid character for size: ")
          end

          last_code = x
        }
        unit = unit.to_s
        num = num.to_s
        @raw = "#{num}#{unit}"
      end # === def initialize

      def to_s
        @raw
      end # === def to_s

    end # === struct Size

  end # === module Node

end # === module DA_CSS
