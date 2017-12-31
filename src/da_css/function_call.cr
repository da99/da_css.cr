
module DA_CSS

  struct Function_Call

    # =============================================================================
    # Instance
    # =============================================================================

    getter name : Token = Token.new
    getter args : Token = Token.new

    def initialize(@name, @args)
    end # === def initialize

    def initialize(raw : Token)
      capture_name = true
      raw.each { |position|
        c = position.char
        case
        when !capture_name || (args.empty? && c == OPEN_PAREN)
          capture_name = false
          @args.push position
        else
          @name.push position
        end
      }
    end # === def initialize

    def to_token
      t = Token.new
      name.each { |p|
        t.push p
      }
      args.each { |p|
        t.push p
      }
      t
    end # === def to_token

    # =============================================================================
    # Class
    # =============================================================================

    def self.looks_like?(t : Token)
      t.last == ')'
    end # === def looks_like?

  end # === struct Function_Call

end # === module DA_CSS
