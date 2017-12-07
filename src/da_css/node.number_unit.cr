
module DA_CSS

  module Node

    struct Number_Unit

      LETTERS = 'a'..'z'
      @number : Number
      @unit   : Unit

      def initialize(raw : Chars)
        nums = Chars.new(raw.parent)
        unit = Chars.new(raw.parent)

        raw.each_with_index { |c, pos|
          case c
          when LETTERS
            unit.push c
          else
            nums.push c
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

      def self.looks_like?(chars : Chars)
        first = chars.first
        last  = chars.last

        return false unless chars.size > 1

        case first
        when '-', '.', Number::RANGE
          true
        else
          return false
        end

        case last
        when LETTERS
          true
        else
          false
        end
      end # === def self.looks_like?

    end # === struct Number_Unit

  end # === module Node

end # === module DA_CSS
