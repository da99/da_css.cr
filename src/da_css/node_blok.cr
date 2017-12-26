
require "./selector_token"
require "./property"

module DA_CSS

  struct Node_Blok

    getter raw : Raw_Blok
    getter head = Deque(Selector_Token).new
    getter body = Deque(Property).new

    def initialize(@raw)
      @raw.selector.each { |token|
        @head.push Selector_Token.new(token)
      }
      @raw.propertys.each { |raw_property|
        @body.push Property.new(raw_property)
      }
    end # === def initialize

    def push(t : Token)
      head.push Selector_Token.new(t)
    end # === def push

    def push(x : Property)
      body.push Property.new(x)
    end # === def push

    def to_s(io)
      @head.join(SPACE, io)
      io << " {\n"
      @body.join(NEW_LINE, io)
      io << "\n}\n"
    end # === def print

  end # === struct Selector

end # === module DA_CSS

