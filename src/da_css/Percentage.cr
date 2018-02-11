
module DA_CSS

  struct Percentage

    getter token : Token

    def initialize(@token)
    end # === def initialize

    def to_s(io)
      @token.to_s(io)
    end # === def to_s

    def self.looks_like?(t : Token)
      first = t.first.char
      last  = t.last.char

      return false if t.size > 8 || t.size < 2

      case first
      when NUMBERS, '-', '.'
        true
      else
        return false
      end

      last == '%'
    end # === def self.looks_like?

  end # === struct Percentage

end # === module DA_CSS
