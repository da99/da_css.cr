
module DA_CSS

  struct Token

    include Enumerable(Position)

    SPACE    = ' '
    NEW_LINE = '\n'

    @raw = Deque(Position).new
    getter pos_line = 0

    def initialize
      @frozen   = false
      @pos_line = 0
    end # === def initialize

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

    def each
      prev = nil
      @raw.each { |c|
        next if prev && prev.whitespace? && c.whitespace?
        yield c
        prev = c
      }
    end # === def each

    def to_s
      to_s(IO::Memory.new)
    end # === def to_s

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
      return io.to_s
    end # === def to_s

    def inspect(io)
      io << "#{self.class}["
      @raw.each_with_index { |c, index|
        io << ", " unless index == 0
        io << c.inspect
      }
      io << "]"
    end # === def inspect

    def raise_if_frozen!
      raise Exception.new("Char_Deque (#{to_s.inspect}) is frozen.") if @frozen
      false
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

    def last
      @raw.last
    end # === def last

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
        '=', ';', '/', '*', '?', '#', '.', ':', '-', '@', ','
        p
      else
        raise CSS_Author_Error.new("Invalid character: #{c.inspect}", self)
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

    def summary
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

    def freeze!
      return self if @frozen
      @frozen = true
      return self
    end

    def pos_summary(str : String)
      l = line
      if l.strip == str.strip
        "#{str.inspect} (Line: #{@pos_line + 1})"
      else
        "#{str.inspect} (Line: #{@pos_line + 1} #{line.inspect})"
      end
    end # === def pos_summary

    def pos_summary
      "Line: #{@pos_line + 1} (#{line.inspect})"
    end # === def pos_summary

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

