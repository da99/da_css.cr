
module DA_CSS

  alias Tokens = Deque(Token)
  struct Token

    include Enumerable(Position)

    SPACE    = ' '
    NEW_LINE = '\n'

    @raw            = Deque(Position).new
    @frozen         = false
    getter pos_line = 0

    delegate first, first?, last, last?, to: @raw

    def initialize
    end # === def initialize

    def initialize(origin : String)
      r = Char::Reader.new(origin)
      r.each { |raw_char|
        @raw.push Position.new(origin, r.pos, r.current_char)
      }
    end # === def initialize

    def split_with_splitter
      splitter = Token_Splitter.new(each)
      while !splitter.done?
        yield splitter.current, splitter
        splitter.next
      end
      splitter.save if splitter.token?
      splitter.tokens
    end # === def split

    def split(char : Char | Nil = nil)
      tokens = Tokens.new
      current = Token.new
      each { |position|
        case
        when ((char == nil && position.char.whitespace?) || position.char == char) && !current.empty?
          tokens << current
          current = Token.new
        else
          current.push position
        end
      }
      if !current.empty?
        tokens << current
      end
      tokens
    end # === def split

    def line
      a_char = @raw.first?
      if a_char
        a_char.line.content
      else
        ""
      end
    end # === def line

    def join(*args)
      @raw.join(*args)
    end

    def select : Token
      t = Token.new
      each { |p|
        t.push(p) if yield(p)
      }
      t
    end # === def select

    def each
      Token_Reader.new(self)
    end # === def reader

    def each_with_reader
      r = each
      while !r.done?
        yield r.current, r
        r.next
      end
    end # === def each_with_reader

    def each
      prev = nil
      @raw.each { |c|
        next if prev && prev.whitespace? && c.whitespace?
        yield c
        prev = c
      }
    end # === def each

    def any?(*chars)
      @raw.any? { |p|
        chars.includes?(p.char)
      }
    end # === def contains?

    def any_inside?(*chars)
      last = @raw.size - 1
      @raw.each_with_index { |p, i|
        next if i == 0 || i == last
        return true if chars.includes?(p.char)
      }
    end # === def any_inside?

    def to_s(io)
      last_i = @raw.size - 1
      @raw.each_with_index { |c, index|
        next if last_i == index && c.whitespace?
        if c.whitespace?
          io << SPACE
        else
          io << c.char
        end
      }

      io
    end # === def to_s

    def inspect(io)
      io << "#{self.class}["
      @raw.each_with_index { |c, index|
        io << ", " unless index == 0
        io << c.inspect
      }
      io << "]"
      io
    end # === def inspect

    def raise_if_frozen!
      raise Exception.new("Char_Deque (#{to_s.inspect}) is frozen.") if @frozen
      false
    end

    def <<(*args)
      push *args
    end

    def push(c : Position)
      raise_if_frozen!
      if !empty? && last.whitespace? && c.whitespace?
        return self
      end

      if empty? && c.whitespace?
        return self
      end

      @raw.push valid!(c)
    end # === def push

    def size
      @raw.size
    end # === def size

    def empty?
      size == 0
    end # === def empty?

    def prev(i : Int32 = 1)
      @raw[@raw.size - i]
    end # === def prev(i : Int32 = 1)

    def [](i : Int32)
      valid!(@raw[i])
    end

    def valid!(p : Position)
      c = p.char
      case c
      when 'A'..'Z', 'a'..'z', '0'..'9',
        ' ', '_',
        '(', ')', '{', '}', '\'', '"',
        '=', ';', '/', '*', '?', '#', '.', ':', '-', '@', ',', '\n'
        p
      else
        raise CSS_Author_Error.new("Invalid character: #{p.summary}")
      end
    end # === def valid_codepoint?

    def pop(i : Int32 = 1)
      raise_if_frozen!
      i.times { |x| @raw.pop }
    end # === def pop

    def all?(r : Range)
      @raw.all? { |c|
        r.includes?(c.ord)
      }
    end # === def all?

    def first_line_summary
      raise Programmer_Error.new("Empty token.") if @raw.empty?
      first = @raw.first
      last = @raw.last

      case
      when first == last
        "Line: #{first.line.number}"
      else
        "Starting at line: #{first.line.number}"
      end
    end # === def first_line_summary

    def summary(all_lines : Bool = false)
      raise Programmer_Error.new("Empty token.") if @raw.empty?
      first = @raw.first
      last = @raw.last

      case
      when first && first == last
        first.summary
      when first && last && first.line.number == last.line.number
        "Line: #{first.line.number} Column: #{first.column.number}-#{last.column.number}"
      when first && last && first.line.number != last.line.number
        "Line: #{first.line.number} - #{last.line.number}"
      else
        first.summary
      end
    end

    def inspect_and_summary
      "#{@raw.to_s.inspect} @ #{summary}"
    end # === def inspect_and_summary

    def last_index
      @size - 1
    end # === def last_index

    def freeze!
      return self if @frozen
      @frozen = true
      return self
    end

    def print(printer : Printer)
      each { |p| printer.raw! p.char }
    end # === def print

    module Common

      def whitespace?(c : Char)
        c.whitespace?
      end # === def whitespace?

      def whitespace?(i : Int32)
        i.chr.whitespace?
      end # === def whitespace?

    end # === module Common

    extend Common
    include Common

  end # === class Token

end # === module DA_CSS

