
module DA_CSS

  struct A_Positive_Whole_Number

    @raw : Token
    def initialize(@raw : Token)
      @raw.each { |p|
        case p.char
        when '0'..'9'
          true
        else
          raise CSS_Author_Error.new("Invalid character for a positive, whole number: #{@raw.inspect_and_summary}")
        end
      }
      if @raw.size > 10
        raise CSS_Author_Error.new("Number is too big: #{@raw.to_s.inspect} @ #{@raw.inspect_and_summary}")
      end
    end # === def initalize

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      t.all? { |p|
        case p.char
        when '0'..'9'
          true
        end
      }
    end # === def self.looks_like?

  end # === struct A_Positive_Whole_Number

end # === module DA_CSS
