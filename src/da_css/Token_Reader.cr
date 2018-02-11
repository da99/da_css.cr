
module DA_CSS

  class Token_Reader

    include Iterator(Position)

    getter index : Int32 = 0
    getter size  : Int32
    getter token : Token
    delegate origin, to: @token

    def initialize(raw : String)
      @token = Token.new(raw)
      @size = @token.size
    end # === def initialize

    def initialize(@token)
      @size = @token.size
    end # === def initialize

    def peek
      return nil if done?
      @token[@index + 1]
    end # === def peek

    def peek?(c : Char)
      p = peek
      return p.char == c if p
      false
    end # === def peek?

    def prev?
      !@index.zero?
    end

    def prev
      raise Exception.new("Already at the beginning.") if @index.zero?
      @token[@index - 1]
    end

    def next!
      @index += 1
      return nil if done?
      @token.positions[@index]
    end

    def next
      next!
      return stop if done?
      @token[@index]
    end

    def first?
      @index == 0
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

    def matches?(*chars)
      char_size = chars.size
      i = @index

      return false if i > (@token.size - char_size)
      chars.each_with_index { |x, char_i|
        return false if x != @token[i + char_i].char
      }

      true
    end # === def matches?

    def comment_starting?
      matches?('/', '*')
    end

    def comment_ending?
      matches?('*', '/' )
    end

    def get?(x : Int32)
      t = Token.new
      current_i = @index
      last_i = @token.size - 1
      x.times { |i|
        break if (current_i + i) > last_i
        t.push @token[current_i + i]
      }
      t
    end # === def get

    def consume_between(a, b, t : Token = Token.new)
      r = self
      starting_position = current
      if !matches?(*a)
        raise CSS_Author_Error.new("Expecting #{a.join.inspect}, but found #{get?(a.size).to_s.inspect}")
      end
      a.size.times { r.next unless r.done? }

      while !r.done?
        if r.matches?(*b)
          b.size.times { r.next }
          return t
        end

        t.push current
        r.next unless r.done?
      end

      if b.size == 1
        raise CSS_Author_Error.new("Missing ending char: #{b.first.inspect} for #{starting_position.summary}")
      else
        raise CSS_Author_Error.new("Missing ending chars: #{b.join.inspect} for #{starting_position.summary}")
      end
    end # === def consume_between

    def consume_through(*args)
      new_token = consume_upto(*args)
      new_token << self.current
      self.next
      new_token
    end # === def consume_through

    def consume_upto_then_next(*args)
      t = consume_upto(*args)
      self.next unless done?
      t
    end # === def consume_upto_then_next

    def consume_upto(open_char : Char, close_char : Char, t : Token = Token.new)
      start = current
      opens = Deque(Position).new
      while !done?
        p = current
        c = p.char
        case c

        when close_char
          break if opens.empty?
          opens.pop
          if opens.empty?
            return t
          else
            t << p
          end

        when '\'', '"'
          t.push p
          self.next
          consume_through(c, t);
          next

        else
          if c == open_char
            opens.push p
          end
          t << p

        end # === case c
        self.next
      end

      case close_char
      when '\'', '"'
        raise CSS_Author_Error.new("String not closed: #{open_char.inspect} for: #{start.summary}")
      else
        raise CSS_Author_Error.new("Closing character not found: #{open_char.inspect} for: #{start.summary}")
      end
    end # === def consume_upto

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
