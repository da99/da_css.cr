
module DA_CSS

  struct Color_Keyword

    # =============================================================================
    # Instance
    # =============================================================================

    @raw  : Token
    @name : String

    def initialize(@raw)
      @name = @raw.to_s
      {% begin %}
        case @name
        when {{ system("cat #{__DIR__}/config/color_keywords.txt").split.map(&.strip).reject(&.empty?).map(&.stringify).join(", ").id }}
          :ok
        else
          raise CSS_Author_Error.new("Invalid Color_Keyword: #{@raw.summary} ")
        end
      {% end %}
    end # === def initialize

    def inspect(io)
      io << "Color_Keyword["
      io << @name
      io << "]"
    end # === def inspect

    def to_s(io)
      io << @name
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      t.all? { |p|
        c = p.char
        case c
        when LOWER_CASE_LETTERS, 'C' # C for the special currentColor keyword
          true
        else
          false
        end
      }
    end # === def self.looks_like?

  end # === struct Color_Keyword

end # === module DA_CSS
