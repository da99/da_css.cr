
module DA_CSS

  struct Node_Media_Query

    # =============================================================================
    # Instance Methods
    # =============================================================================

    getter head : Token
    getter body : Deque(Node_Blok)

    def initialize(raw)
      @head = self.class.validate_head!( raw.head )
      @body = self.class.validate_body!( raw.body )
    end # === def initialize

    def to_s(io)
      io << "@"
      head.to_s(io)
      io << " {\n"
      body.each { |blok|
        blok.to_s(io)
      }
      io << "}\n"
    end # === def print

    # =============================================================================
    # Class Methods
    # =============================================================================
    def self.validate_head!(raw_token : Token)
      raw_token.each { |position|
        c = position.char
        case c
        when 'a'..'z', '(', ')', ':', '0'..'9', ',', '-', ' '
          :accepted
        else
          raise CSS_Author_Error.new("Invalid character for media query: #{c.inspect} at #{position.summary}")
        end
      }
      raw_token
    end # === def self.validate_head!

    def self.validate_body!(raw_bloks : Deque(Raw_Blok))
      clean = Deque(Node_Blok).new
      raw_bloks.each { |raw_blok|
        clean << Node_Blok.new(raw_blok)
      }
      clean
    end # === def self.validate_body!

  end # === struct Node_Media_Query

end # === module DA_CSS
