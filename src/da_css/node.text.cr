
module DA_CSS

  module Node

    class Invalid_Text < Exception

      def initialize(str : String)
        @message = "Invalid string: #{str}"
      end # === def initialize

      def initialize(cp : Codepoints)
        @message = "Invalid string: #{cp.to_s.inspect}"
      end # === def initialize

    end # === class Invalid_Text

    struct Text

      @raw : Codepoints
      def initialize(@raw)
        @raw.each { |x| self.class.valid!(x) }
      end # === def initialize

      def to_s
        @raw.each { |x| self.class.valid!(x) }
        "'#{@raw.to_s}'"
      end

      def print(printer : Printer)
        printer.raw! "'"
        @raw.print printer
        printer.raw! "'"
        self
      end # === def print

      def self.valid!(i : Int32)
        case i
        when '\''.hash, '"'.hash
          raise Invalid_Text.new("Text can't contain single/double quotation marks: #{i.chr}.inspect")
        else
          true
        end
      end # === def valid!

    end # === struct String

  end # === module Node

end # === module DA_CSS
