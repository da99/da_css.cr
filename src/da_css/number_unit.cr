
module DA_CSS

  struct Number_Unit

    @number : Number
    @unit   : Unit

    def initialize(t : Token)
      @number = Number.new(t.select { |p| !p.letter? })
      @unit = Unit.new(t.select(&.letter?))
    end # === def initialize

    def to_s
      "#{@number.to_s}#{@unit.to_s}"
    end # === def to_s

    def print(printer : Printer)
      @number.print(printer)
      @unit.print(printer)
      self
    end # === def print

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
      when LETTERS
        true
      else
        false
      end
    end # === def self.looks_like?

  end # === struct Number_Unit

end # === module DA_CSS
