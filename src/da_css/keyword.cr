
module DA_CSS

  struct Keyword

    # =============================================================================
    # Instance
    # =============================================================================

    @raw  : Token
    @name : String

    def initialize(@raw)
      @name = @raw.to_s
      {% begin %}
        case @name
        when {{ system("cat #{__DIR__}/keywords.txt").split.map(&.strip).reject(&.empty?).map(&.stringify).join(", ").id }}
          :ok
        end
      {% end %}
    end # === def initialize

    def to_s
      @name
    end # === def to_s

    def print(printer : Printer)
      printer.raw! @name
    end # === def print

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      !(t.any? { |p| p.char.whitespace? })
    end # === def self.looks_like?

  end # === struct Keyword

end # === module DA_CSS
