
module DA_CSS

  module Node

    struct Number_Unit

      LETTERS = ('a'.hash)..('z'.hash)
      @number : Number
      @unit   : Unit

      def initialize(raw : Codepoints)
        nums = Codepoints.new
        unit = Codepoints.new

        raw.each_with_index { |x, pos|
          case x
          when LETTERS
            unit.push x
          else
            nums.push x
          end
        }

        @number = Number.new(nums)
        @unit   = Unit.new(unit)
      end # === def initialize

      def to_s
        "#{@number.to_s}#{@unit.to_s}"
      end # === def to_s

      def print(printer : Printer)
        @number.print(printer)
        @unit.print(printer)
        self
      end # === def print

      def self.looks_like?(cp : Codepoints)
        first = cp.first
        last  = cp.last

        return false unless cp.size > 1

        case first
        when '-'.hash, '.'.hash, Number::RANGE
          true
        else
          return false
        end

        case last
        when ('a'.hash)..('z'.hash)
          true
        else
          false
        end
      end # === def self.looks_like?

    end # === struct Number_Unit

  end # === module Node

end # === module DA_CSS
