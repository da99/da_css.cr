
module DA_CSS

  struct Blok

    # =============================================================================
    # Instance
    # =============================================================================

    getter selectors = Deque(Selector).new
    getter propertys = Deque(Property).new

    def initialize(raw_selector : Token, raw_body : Token)
      raw_selector.split(',').each { |t|
        @selectors.push Selector.new(t)
      }

      raw_body.reader {
        next if current.whitespace?
        c = current.char
        case
        when c == '/' && comment_starting?
          consume_between({'/', '*'}, {'*', '/'})
        else
          @propertys.push Property.new(consume_upto_then_next ';')
        end
      }
    end # === def initialize

    def to_s(io)
      @selectors.join(", ", io)
      io << ' ' << OPEN_BRACKET << '\n'
      @propertys.join('\n', io)
      io << '\n' << CLOSE_BRACKET
    end # === def to_s

    # =============================================================================
    # Class
    # =============================================================================

  end # === struct Blok

end # === module DA_CSS
