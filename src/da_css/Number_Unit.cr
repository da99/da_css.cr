
module DA_CSS

  struct Number_Unit

    getter a_number : A_Number
    getter unit   : Unit

    def initialize(t : Token)
      @a_number = A_Number.new(t.select { |p| !p.letter? })
      @unit = Unit.new(t.select(&.letter?))
    end # === def initialize

    def inspect(io)
      io << self.class.name << "["
      @a_number.inspect(io)
      @unit.inspect(io)
      io << "]"
    end

    def to_s(io)
      @a_number.to_s(io)
      @unit.to_s(io)
    end # === def to_s

    def self.looks_like?(t : Token)
      first = t.first
      last  = t.last

      return false unless t.size > 1

      case first.char
      when '-', '.', NUMBERS
        true
      else
        return false
      end

      case last.char
      when LOWER_CASE_LETTERS
        true
      else
        false
      end
    end # === def self.looks_like?

  end # === struct Number_Unit

end # === module DA_CSS
