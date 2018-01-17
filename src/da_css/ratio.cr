
module DA_CSS

  struct Ratio

    @raw : Token

    def initialize(@raw)
      top = false
      bottom = false
      fill_top = true
      is_invalid = false
      @raw.each { |p|
        c = p.char
        case c
        when '0'..'9'
          if fill_top
            top = true
          else
            bottom = false
          end
        when SLASH
          fill_top = false
        else
          is_invalid = true
        end
      }

      if !top || !bottom || is_invalid
        raise CSS_Author_Error.new("Invalid ratio: #{@raw.summary}")
      end
    end # === def initialize

    def to_s(io)
      @raw.to_s(io)
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      t.all? { |p|
        case p.char
        when '0'..'9', SLASH
          true
        else
          false
        end
      }
    end # === def self.looks_like?

  end # === struct Ratio

end # === module DA_CSS
