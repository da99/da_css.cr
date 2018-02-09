
module DA_CSS

  struct Selector

    def initialize(t : Token)
      t.reader { |reader|
        c = current.char
        case c
        when '\'', '"'
          reader.next
          consume_through(c)

        when LOWER_CASE_LETTERS, NUMBERS,
          '!', '#', '.', ':', ' ', '_',
          '[', ']', '=', '^'
          true
        else
          raise CSS_Author_Error.new("Invalid character for selector #{t.to_s.inspect}: #{current.summary}")
        end # === case c
      }
      @raw = t
    end # === def initialize

    def to_s(io)
      @raw.to_s(io)
    end # === def to_s

  end # === struct Selector

end # === module DA_CSS
