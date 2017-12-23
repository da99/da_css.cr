
module DA_CSS

  class Origin

    @reader : Char::Reader
    @raw    : String
    getter line_num = 0

    delegate string, pos, has_next?, to: @reader

    def initialize(@raw)
      @reader = Char::Reader.new(raw)
    end # === def initialize

    def done?
      !current_char? || !has_next? || current_raw_char == '\0'
    end # === def done?

    def parse
      Parser.new(self).parse
    end # === def parse

    def current_char?
      (current_char) ? true : false
    end

    def current_char?(c : Char)
      current_char == c
    end # === def current_char?

    def current_raw_char
      @reader.current_char
    end # === def current_raw_char

    def current_char
      A_Char.new(self)
    end # === def current_char

    def next_char
      c = current_raw_char
      @line_num += 1 if c == '\n'
      @reader.next_char
      A_Char.new(self)
    end # === def next_char

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

    def next_char?
      @reader.has_next?
    end

    def inspect(io)
      io << "Origin[\n"
      io << @raw
      io << "\n]"
    end # === def inspect

  end # === class Origin

end # === module DA_CSS
