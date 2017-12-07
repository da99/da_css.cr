
module DA_CSS

  module Node

    class Invalid_Slash < Exception

      def initialize(cp : Chars)
        @message = "Invalid slash character: #{cp.to_s.inspect}"
      end

    end # === class Invalid_Slash

    struct Slash

      SLASH = '/'

      def initialize(chars : Chars)
        if chars.size != 1 && chars.first != SLASH
          raise Invalid_Slash.new(chars)
        end
      end # === def initialize

      def to_s
        "/"
      end # === def to_s

      def print(printer : Printer)
        printer.raw! "/"
        self
      end # === def print

      def self.looks_like?(chars : Chars)
        chars.size == 1 && chars.first == SLASH
      end # === def self.looks_like?

    end # === struct Slash

  end # === module Node

end # === module DA_CSS

