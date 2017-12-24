
module DA_CSS
  module Node

    class Invalid_Statement < Exception

      def initialize(str : String)
        @message = "Invalid statement: #{str}"
      end # === def initialize

    end # === class Invalid_Statement

    struct Statement
      getter raw : Token

      def initialize(@raw)
      end # === def initialize

      def to_s
        @raw.to_s
      end # === def to_s

      def each
        @raw.split.each { |chars|
          yield chars
        }
      end # === def each

      def to_s(io_css : IO_CSS)
        @raw.split.each_with_index { |chars, i|
          io_css.raw! ' ' if i != 0
          chars.each { |x|
            io_css.raw! x
          }
        }
        self
      end # === def to_s

    end # === struct Statement

  end # === module Node
end # === module DA_CSS
