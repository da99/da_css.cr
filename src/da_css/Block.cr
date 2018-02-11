
module DA_CSS

  struct Block

    # =============================================================================
    # Instance
    # =============================================================================

    getter selectors = Deque(Selector).new
    getter propertys = Deque(Property).new

    def initialize(raw_selector : Token, raw_body : Token)
      raw_selector.split(',').each { |t|
        @selectors.push Selector.new(t)
      }

      raw_body.each_with_reader { |current, reader|
        next if current.whitespace?
        c = current.char
        case
        when c == '/' && reader.comment_starting?
          reader.consume_between({'/', '*'}, {'*', '/'})
        else
          @propertys.push Property.new(reader.consume_upto_then_next ';')
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

  end # === struct Block

end # === module DA_CSS
