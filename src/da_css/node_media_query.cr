
module DA_CSS

  struct Node_Media_Query

    def self.validate_selector_tokens!(tokens : Deque(Token))
      clean = Deque(Token).new
      tokens.each_with_index { |t, i|
        case i
        when 0
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
      tokens
    end # === def self.validate_selector_tokens

    def self.validate_body!(raw_bloks : Deque(Raw_Blok))
      clean = Deque(Node_Blok).new
      raw_bloks.each { |raw_blok|
        clean << Node_Blok.new(raw_blok)
      }
      clean
    end # === def self.validate_body!

    getter selector_tokens : Deque(Token)
    getter body : Deque(Node_Blok)

    def initialize(raw)
      @selector_tokens = self.class.validate_selector_tokens!( raw.selector_tokens )
      @body = self.class.validate_body!( raw.blok )
    end # === def initialize

    def to_s(io)
      io << "@"
      selector_tokens.join(SPACE, io)
      io << " {\n"
      body.each { |blok|
        blok.to_s(io)
      }
      io << "}\n"
    end # === def print

  end # === struct Node_Media_Query

end # === module DA_CSS
