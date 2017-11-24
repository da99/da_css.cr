

module DA_CSS

  module Node

    struct Property

      getter key   : Key
      getter value : Value

      def initialize(raw_key : Codepoints, raw_value : Doc)
        @key = Key.new(raw_key)
        @value = Value.new(raw_key, raw_value)
      end # === def initialize

      def print(printer : Printer)
        printer.new_line
        key.print(printer)
        printer.raw! ": "
        value.print(printer)
        printer.raw! ";"
        self
      end # === def print

      struct Key

        @name : String

        def initialize(codepoints : Codepoints)
          @name = codepoints.to_s
          self.class.valid!(@name)
        end # === def initialize

        def self.valid_char!(i : Int32)
          case i
          when ('a'.hash)..('z'.hash), '-'.hash
            true
          else
            raise Invalid_Char.new(i, "Invalid char for property name: ")
          end
        end # === def self.valid_char?

        def self.valid!(raw : String)
          {% begin %}
          case raw
          when {{ system("cat \"#{__DIR__}/propertys.txt\"").split("\n").reject(&.empty?).map(&.stringify).join(", ").id }}
            true
          else
            raise Invalid_Property_Name.new(raw)
          end
          {% end %}
        end # === def self.valid!

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
        @raw : Array(Types)
        include Enumerable(Types)

        def initialize(key, doc : Doc)
          @raw = [] of Value::Types
          if doc.empty?
            raise Invalid_Property_Value.new("Missing value: #{key.to_s}")
          end
          doc.each { |x|
            case x
            when Types
              @raw.push x
            else
              raise Invalid_Property_Value.new(x.to_s.inspect)
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
              raise Invalid_Property_Value.new(x.to_s)
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
    end # === struct Property
  end # === module Node
end # === module DA_CSS
