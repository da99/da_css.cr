
module DA_CSS

  class Origin

    @reader : Char::Reader
    @raw    : String
    @dir    : String
    @done   : Bool = false

    delegate string, pos, current_char, next_char, has_next?, peek_next_char, to: @reader

    def initialize(@raw, @dir)
      @reader = Char::Reader.new(raw)
    end # === def initialize

    def done?
      @done || !current_char? || !has_next?
    end # === def done?

    def parse
      raise Error.new("Already parsed.") if done?
      result = Parser.new(self).parse
      @done = true
      self
    end # === def parse

    def current_char?
      (current_char) ? true : false
    end

    def current_char?(c : Char)
      current_char == c
    end # === def current_char?

    def skip_to(c : Char)
      if current_char? && !current_char.whitespace?
        next_char = next? && peek
        if next_char && next_char.whitespace?
          next_char
        end
      end

      while (curr = current_char) && curr && curr.whitespace?
        next_char
      end

      return self if current_char == c
      raise Error.new("Not found: #{c.inspect}")
    end # === def skip_to

    def inspect(io)
      io << "Origin[\n"
      io << @raw
      io << "\n]"
    end # === def inspect

  end # === class Origin

end # === module DA_CSS
