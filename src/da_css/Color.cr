
module DA_CSS

  struct Color

    getter token : Token
    delegate parent, to: @token

    def initialize(@token)
      @token.each_with_index { |position, index|
        c = position.char
        case
        when index == 0 && c == HASH
          next
        when index > 0 && index < 9 && (
          UPPER_CASE_LETTERS.includes?(c) || LOWER_CASE_LETTERS.includes?(c) || NUMBERS.includes?(c)
        )
          next
        end
        raise CSS_Author_Error.new("Invalid color", @token)
      }
    end # === def initialize

    def to_s(io)
      @token.to_s(io)
    end # === def to_s

    def self.looks_like?(t : Token)
      return false if t.first.char != HASH
      case t.size
      when 3+1, 4+1, 6+1, 8+1
        true
      end
    end # === def self.looks_like?
  end # === struct Color

end # === module DA_CSS
