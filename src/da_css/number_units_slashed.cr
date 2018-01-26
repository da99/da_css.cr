
module DA_CSS

  struct Number_Units_Slashed

    # =============================================================================
    # Instance
    # =============================================================================

    @first  : Number_Unit
    @second : Number_Unit

    def initialize(t : Token)
      tokens = t.split('/')
      if tokens.size != 2
        raise CSS_Author_Error.new("Invalid value: #{t.summary}")
      end
      @first  = Number_Unit.new(tokens.first)
      @second = Number_Unit.new(tokens.last)
    end # === def initialize

    def inspect(io)
      io << self.class.name << "["
      @first.to_s(io)
      io << '/'
      @second.to_s(io)
      io << "]"
    end

    def to_s(io)
      @first.to_s(io)
      io << '/'
      @second.to_s(io)
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      first = t.first
      last  = t.last

      return false unless t.any?('/')
      return false unless t.size > 5

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
