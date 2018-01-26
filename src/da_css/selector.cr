
module DA_CSS

  struct Selector

    def initialize(t : Token)
      t.each { |position|
        c = position.char
        case c
        when LOWER_CASE_LETTERS, '#', '.', ':', ' ', '_'
          true
        else
          raise CSS_Author_Error.new("Invalid character for selector #{t.to_s.inspect}: #{position.summary}")
        end # === case c
      }
      @raw = t
    end # === def initialize

    def to_s(io)
      @raw.to_s(io)
    end # === def to_s

  end # === struct Selector

end # === module DA_CSS
