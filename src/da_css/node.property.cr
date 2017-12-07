

module DA_CSS

  module Node

    struct Property

      class Invalid_Name < Error
        def message
          "Invalid property name: #{@message}"
        end # === def message
      end # === class Invalid_Name < Error

      class Invalid_Value < Error
        def message
          "Invalid property value: #{@message}"
        end # === def message
      end # === class Invalid_Name < Error

      include Node

      struct Key

        @name : String

        def initialize(chars : Chars)
          @name = chars.to_s
          self.class.valid!(@name)
        end # === def initialize

        def self.valid_char!(c : Char)
          case c
          when 'a'..'z', '-'
            true
          else
            raise Invalid_Char.new(c, "Invalid char for property name: ")
          end
        end # === def self.valid_char?

        def self.valid!(raw : String)
          {% begin %}
          case raw
          when {{ system("cat \"#{__DIR__}/propertys.txt\"").split("\n").reject(&.empty?).map(&.stringify).join(", ").id }}
            true
          else
            raise Invalid_Name.new(raw)
          end
          {% end %}
        end # === def self.valid!

        def to_s
          @name
        end # === def to_s

        def print(printer : Printer)
          printer.raw! @name
          self
        end # === def print

        def to_css(io : IO_CSS)
          io.raw! @name
        end

      end # === struct Key

      struct Value

        alias Types = Number_Unit | Number | Percentage | Keyword | Slash | Unknown | Color | Function_Call
        @raw : Deque(Types)
        include Enumerable(Types)

        def initialize(key, doc : NODES)
          @raw = Deque(Value::Types).new
          if doc.empty?
            raise Invalid_Value.new("Missing value: #{key.to_s}")
          end
          doc.each { |x|
            case x
            when Types
              @raw.push x
            else
              raise Invalid_Value.new(x.to_s.inspect)
            end
          }
        end # === def initialize

        def print(printer : Printer)
          @raw.each_with_index { |x, i|
            printer.raw! " " if i != 0
            x.print(printer)
          }
          self
        end # === def print

        def size
          @raw.size
        end # === def size

        def each
          @raw.each { |x| yield x }
        end # === def each

        def all!(klass)
          @raw.each { |x|
            case
            when klass
              true
            else
              raise Invalid_Value.new(x.to_s)
            end
          }
        end # === def all!

        def to_css(io : IO_CSS)
          @raw.each_with_index { |x, pos|
            io.raw! ' ' if pos != 0
            io.raw! x.to_s
          }
        end
      end # === struct Value

      getter key    : Key
      getter value  : Parser
      getter parent : Parser

      def initialize(raw_key : Chars, parent : Parser)
        raise Invalid_Name.new("Property being defined with a key") if raw_key.empty?
        @parent = parent
        @key    = Key.new(raw_key)
        @value  = doc = Parser.new
        doc.reader = parent
        doc.parent = self
        doc.parse
        if !doc.nodes?
          raise Invalid_Value.new("Empty value for property: #{@key.to_s.inspect}")
        end
      end # === def initialize

      def print(printer : Printer)
        printer.new_line(parent)
        key.print(printer)
        printer.raw! ": "
        value.print(printer)
        printer.raw! ";"
        self
      end # === def print

    end # === struct Property
  end # === module Node
end # === module DA_CSS
