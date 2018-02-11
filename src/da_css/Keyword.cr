
module DA_CSS

  struct Keyword

    # =============================================================================
    # Instance
    # =============================================================================

    getter token  : Token
    @name : String

    def initialize(@token)
      @name = @token.to_s
      {% begin %}
        case @name
        when {{ system("cat #{__DIR__}/config/keywords.txt").split.map(&.strip).reject(&.empty?).map(&.stringify).join(", ").id }}
          :ok
        else
          raise CSS_Author_Error.new("Invalid keyword: #{@token.summary} ")
        end
      {% end %}
    end # === def initialize

    def inspect(io)
      io << "Keyword["
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
        when LOWER_CASE_LETTERS, '-'
          true
        else
          false
        end
      }
    end # === def self.looks_like?

  end # === struct Keyword

end # === module DA_CSS
