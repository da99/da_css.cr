
module DA_CSS

  class Token_Reader

    include Iterator(Position)

    getter index : Int32 = 0
    getter size : Int32
    getter token : Token
    delegate origin, to: @token

    def initialize(raw : String)
      @token = Token.new(raw)
      @size = @token.size
    end # === def initialize

    def initialize(@token)
      @size = @token.size
    end # === def initialize

    def prev?
      !@index.zero?
    end

    def prev
      raise Exception.new("Already at the beginning.") if @index.zero?
      @token[@index - 1]
    end

    def next
      @index += 1
      return stop if done?
      @token[@index]
    end

    def last?
      @index == (@size - 1)
    end

    def done?
      @index >= @size
    end

    def current
      @token[@index]
    end # === def current

    def current?
      !done?
    end

    def consume_through(*args)
      new_token = consume_upto(*args)
      new_token << self.current
      self.next
      new_token
    end # === def consume_through

    def consume_upto(target : Char, t : Token = Token.new)
      start = current
      while !done?
        p = current
        c = p.char
        case c
        when target
          return t

        when '\'', '"'
          t.push p
          self.next
          consume_through(c, t);
          next

        else
          t << p

        end # === case c
        self.next
      end

      case target
      when '\'', '"'
        raise CSS_Author_Error.new("String not closed: #{target.inspect} for: #{start.summary}")
      else
        raise CSS_Author_Error.new("Closing character not found: #{target.inspect} for: #{start.summary}")
      end
    end # === def consume_upto

  end # === struct Token_Reader

end # === module DA_CSS
