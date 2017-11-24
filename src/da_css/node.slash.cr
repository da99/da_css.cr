
module DA_CSS

  module Node

    class Invalid_Slash < Exception

      def initialize(cp : Codepoints)
        @message = "Invalid slash character: #{cp.to_s.inspect}"
      end

    end # === class Invalid_Slash

    struct Slash

      SLASH = '/'.hash

      def initialize(cp : Codepoints)
        if cp.size != 1 && cp.first != SLASH
          raise Invalid_Slash.new(cp)
        end
      end # === def initialize

      def to_s
        "/"
      end # === def to_s

      def print(printer : Printer)
        printer.raw! "/"
        self
      end # === def print

      def self.looks_like?(cp : Codepoints)
        cp.size == 1 && cp.first == SLASH
      end # === def self.looks_like?

    end # === struct Slash

  end # === module Node

end # === module DA_CSS
