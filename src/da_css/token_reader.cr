
module DA_CSS

  class Token_Reader

    include Iterator(Position)

    getter token : Token
    getter index : Int32 = 0
    getter size : Int32

    def initialize(@token)
      @size = @token.size
    end # === def initialize

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

    def consume_through(*args)
      new_token = consume_upto(*args)
      new_token << self.current
      self.next
      new_token
    end # === def consume_through

    def consume_upto(target : Char)
      start = current
      t = Token.new
      while !done?
        p = current
        c = p.char
        case c
        when target
          return t
        else
          t << p
        end
        self.next
      end
      raise CSS_Author_Error.new("Closing character not found: #{target.inspect} (for #{start.summary})")
    end # === def consume_upto

  end # === struct Token_Reader

end # === module DA_CSS
