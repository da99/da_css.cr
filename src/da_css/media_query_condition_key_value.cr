
module DA_CSS

  struct Media_Query_Condition_Key_Value

    # =============================================================================
    # Instance
    # =============================================================================

    @raw : Token
    @key : String
    @value : String

    def initialize(@raw : Token)
      key = Token.new
      value = Token.new
      fill_val = false
      last = @raw.size - 1
      @raw.each_with_index { |p, i|
        c = p.char
        case
        when c == OPEN_PAREN && i == 0
          next
        when c == CLOSE_PAREN && i == last
          next
        when c == ':'
          fill_val = true
        when fill_val
          value.push p
        else
          key.push p
        end
      }
      @key, @value = self.class.valid!(key, value)
    end # === def initialize

    def to_s(io)
      io << OPEN_PAREN
      io << @key
      io << ':' << ' '
      io << @value
      io << CLOSE_PAREN
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

    # "update", "scripting", "light-level" left out for now.
    def self.valid!(key : Token, value : Token)
      k = key.to_s
      v = value.to_s
      case k
      when "orientation"
        case v
        when "portrait", "landscape"
          return {k,v}
        end

      when "scan"
        case  v
        when "interlace", "progressive"
          return {k,v}
        end

      when "grid"
        case v
        when "0", "1"
          return {k,v}
        end

      when "overflow-block"
        case v
        when "none", "scroll", "optional-paged", "paged"
          return {k,v}
        end

      when "overflow-inline"
        case v
        when "none", "scroll"
          return {k,v}
        end

      when "color-gamut"
        case v
        when "srgb", "p3", "rec2020"
          return {k,v}
        end

      when "display-mode"
        case v
        when "fullscreen", "standalone", "minimal-ui", "browser"
          return {k,v}
        end

      when "inverted-colors"
        case v
        when "none", "inverted"
          return {k,v}
        end

      when "pointer"
        case v
        when "none", "coarse", "fine"
          return {k,v}
        end

      when "hover", "any-hover"
        case v
        when "none", "hover"
          return {k,v}
        end

      when "any-pointer"
       case v
       when "none", "coarse", "fine"
         return {k,v}
       end

      when "min-monochrome", "max-monochrome", "monochrome"
        return {k, A_Number.new(value).to_s}

      when "min-width", "max-width", "width",
           "min-height", "max-height", "height"
        case
        when Number_Unit.looks_like?(value)
          return {k, Number_Unit.new(value).to_s}
        end

      when "min-resolution", "max-resolution", "resolution"
        case
        when Number_Unit.looks_like?(value)
          return {k, Number_Unit.new(value).to_s}
        end

      when "min-aspect-ratio", "max-aspect-ratio", "aspect-ratio"
        case
        when Ratio.looks_like?(value)
          return {k, Ratio.new(value).to_s}
        end

      when "min-color-index", "max-color-index", "color-index"
        case
        when A_Positive_Whole_Number.looks_like?(value)
          return {k, A_Positive_Whole_Number.new(value).to_s}
        end

      when "min-monochrome", "max-monochrome", "monochrome"
        case
        when A_Positive_Whole_Number.looks_like?(value)
          return {k, A_Positive_Whole_Number.new(value).to_s}
        end

      when "min-color", "max-color", "color"
        case
        when A_Positive_Whole_Number.looks_like?(value)
          return {k, A_Positive_Whole_Number.new(value).to_s}
        end

      else
        raise CSS_Author_Error.new("Invalid query rule: #{k.inspect} @ #{key.summary}")
      end

      raise CSS_Author_Error.new("Invalid query value for #{k.inspect}: #{v.inspect} @ #{value.summary}")
    end # === def self.valid_key?

  end # === struct Media_Query_Condition_Key_Value

end # === module DA_CSS
