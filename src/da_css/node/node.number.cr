
module DA_CSS

  module Node

    struct Number

      class Invalid < Error

        def initialize(str : String)
          @message = "Invalid Number: #{str.inspect}"
        end # === def initialize

        def initialize(cp : Char_Deque)
          @message = "Invalid Number: #{cp.to_s.inspect}"
        end # === def initialize

      end # === class Invalid


      RANGE = '0'..'9'
      @raw : Char_Deque

      def initialize(@raw)
        if @raw.size > 8
          raise Number::Invalid.new(@raw)
        end
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def print(printer : Printer)
        @raw.print printer
      end # === def print

      def self.looks_like?(chars : Char_Deque)
        first = chars.first
        last  = chars.last

        case first
        when '-', '.', RANGE
          true
        else
          return false
        end # === case first

        case last
        when RANGE
          true
        else
          return false
        end
      end # === def self.looks_like?

    end # === struct Number

  end # === module Node

end # === module DA_CSS
