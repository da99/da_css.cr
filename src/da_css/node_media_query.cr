
module DA_CSS

  struct Node_Media_Query

    # =============================================================================
    # Instance Methods
    # =============================================================================

    getter head : Tokens
    getter body : Deque(Node_Blok)

    def initialize(raw)
      @head = self.class.validate_head!( raw.head )
      @body = self.class.validate_body!( raw.body )
    end # === def initialize

    def to_s(io)
      io << "@"
      head.join(SPACE, io)
      io << " {\n"
      body.each { |blok|
        blok.to_s(io)
      }
      io << "}\n"
    end # === def print

    # =============================================================================
    # Class Methods
    # =============================================================================
    def self.validate_head!(tokens : Tokens)
      clean = Tokens.new
      tokens.each_with_index { |raw_token, i|
        raw_token.split.each { |t|
          if clean.empty?
            word = t.to_s
            case word
            when "media"
              :accepted
            else
              raise CSS_Author_Error.new(%[Expecting "media", but got #{word.inspect} instead: #{t.summary}])
            end
          else
            t.each { |p| # each position
              case p.char
              when 'a'..'z', '(', ')', ':', '_', '0'..'9', ',', '-'
                :accepted
              else
                raise CSS_Author_Error.new("Invalid character for media query: #{p.summary}")
              end
            }
          end

          clean << t
        }
      }
      tokens
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
