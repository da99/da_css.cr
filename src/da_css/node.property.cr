

module DA_CSS

  module Node

    struct Property

      getter key   : Key
      getter value : Value

      def initialize(raw_key : Codepoints, raw_value : Doc)
        @key = Key.new(raw_key)
        @value = Value.new(raw_value)
      end # === def initialize

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

        def to_s
          @name
        end

      end # === struct Key

      struct Value

        alias CSS_PROPERTY_VALUE = Size | Percentage | Keyword | Unknown | Color
        @raw : Array(CSS_PROPERTY_VALUE)

        def initialize(doc : Doc)
          @raw = [] of CSS_PROPERTY_VALUE
          doc.each { |x|
            case x
            when Node::Statement
              x.each { |codepoints|
                @raw.push Value.from_codepoints(codepoints)
              }
            else
              raise Exception.new("Invalid chars for property value: #{x.to_s.inspect}")
            end
          }
        end # === def initialize

        def each
          @raw.each_with_index { |x, pos|
            yield ' ' if pos != 0
            yield x.to_s
          }
        end # === def each

        def self.from_codepoints(c : Codepoints)
          first = c.first
          last = c.last
          case
          when first == '#'.hash
            Color.new(c)

          when (last != '%'.hash) && (first == '-'.hash || first == '.'.hash || (('0'.hash)..('9'.hash)).includes?(first))
            Size.new(c)

          when last == '%'.hash && (('0'.hash)..('9'.hash)).includes?(first)
            Percentage.new(c)

          else
            word = c.to_s
            {% begin %}
            case word
            when {{ system("cat \"#{__DIR__}/keywords.txt\"").split("\n").reject(&.empty?).map(&.stringify).join(", ").id }}
              Keyword.new(word)
            else
              raise Invalid_Property_Value.new(word)
            end
            {% end %}

          end
        end # === def self.from_codepoints

      end # === struct Value
    end # === struct Property
  end # === module Node
end # === module DA_CSS
