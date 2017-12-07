
module DA_CSS

  module Node

    struct Selector

      include Enumerable(Char)

      @raw : Deque(Selector::Partial)
      def initialize(group : Chars::Group)
        @raw = Deque(Selector::Partial).new
        group.each { |chars|
          @raw.push Selector::Partial.new(chars)
        }
      end # === def initialize

      def each
        @raw.each_with_index { |partial, pos|
          yield(' ') if pos != 0
          partial.each { |c|
            yield c
          }
        }
      end # === def each

      def print(printer : Printer)
        if @raw.empty?
          raise Error.new("Selector is empty.")
        end

        @raw.each_with_index { |x, i|
          printer.raw! " " if i != 0
          x.print printer
        }
        self
      end # === def print

      struct Partial

        include Enumerable(Char)
        @raw : Chars
        def initialize(@raw)
          @raw.each { |i|
            Selector.valid_char!(i, @raw)
          }
        end

        def each
          @raw.each { |i|
            yield i
          }
        end # === def each

        def print(printer : Printer)
          @raw.print printer
          self
        end # === def print

      end # === struct Partial

      def self.valid_char!(c : Char, chars : Chars)
        case c
        when 'a'..'z', '0'..'9', '.', '-', '_', '#'
          true
        else
          raise Error.new("Invalid character for selector: #{c.inspect} (in #{chars.join.inspect})", chars)
        end
      end # === def self.valid_char?
    end # === struct Selector

  end # === module Node

end # === module DA_CSS
