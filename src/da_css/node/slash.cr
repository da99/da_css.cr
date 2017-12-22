
module DA_CSS

  module Node

    class Invalid_Slash < Exception

      def initialize(cp : A_Char_Deque)
        @message = "Invalid slash character: #{cp.to_s.inspect}"
      end

    end # === class Invalid_Slash

    struct Slash

      SLASH = '/'
      SLASH_STRING = "/"

      @raw : A_Char_Deque
      def initialize(chars : A_Char_Deque)
        @raw = chars
        if chars.size != 1 && chars.first != SLASH
          raise Invalid_Slash.new(chars)
        end
      end # === def initialize

      def to_s
        SLASH_STRING
      end # === def to_s

      def print(printer : Printer)
        printer.raw! SLASH_STRING
        self
      end # === def print

      def self.looks_like?(chars : A_Char_Deque)
        chars.size == 1 && chars.first == SLASH
      end # === def self.looks_like?

    end # === struct Slash

  end # === module Node

end # === module DA_CSS

