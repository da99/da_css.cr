
module DA_CSS

  struct Codepoints

    include Enumerable(Int32)

    SPACE    = ' '.hash
    NEW_LINE = ' '.hash

    @raw : ::Array(Int32) = [] of Int32

    def initialize
      @frozen = false
    end # === def initialize

    def initialize(raw : String)
      @raw = raw.codepoints
      @frozen = true
    end # === def initialize

    def initialize(@raw : ::Array(Int32))
      @frozen = true
    end # === def initialize

    def each
      prev = nil
      @raw.each { |i|
        next if prev && whitespace?(prev) && whitespace?(i)
        yield i
        prev = i
      }
    end # === def each

    def to_s
      io = IO::Memory.new
      last_i = @raw.size - 1
      @raw.each_with_index { |i, index|
        io << i.chr unless last_i == index && whitespace?(i)
      }
      return io.to_s
    end # === def to_s

    def inspect(io)
      io << "Codepoints["
      @raw.each_with_index { |x, i|
        io << ", " unless i == 0
        io << x.chr.inspect
      }
      io << "]"
    end # === def inspect

    def raise_if_frozen!
      raise Exception.new("Codepoints (#{to_s.inspect}) is frozen.") if @frozen
      false
    end

    def push(i : Int32)
      raise_if_frozen!
      if !empty? && whitespace?(last) && whitespace?(i)
        return self
      end
      if empty? && whitespace?(i)
        return self
      end

      new_code = valid!(i)

      @raw.push new_code
    end # === def push

    def last
      @raw[size - 1]
    end # === def last

    def size
      @raw.size
    end # === def size

    def empty?
      size == 0
    end # === def empty?

    def [](i : Int32)
      valid!(@raw[i])
    end

    def valid!(i : Int32)
      case i
      when (code('A')..code('Z')),
        (code('a')..code('z')),
        (code('0')..code('9')),
        code(' '), code('\n'), code(':'), code('-'),
        code('('), code(')'),
        code('{'), code('}'),
        code('\''), code('"'),
        code('='), code(';'),
        code('/'), code('*'), code('?'), '#'.hash, '.'
        i
      else
        raise Invalid_Char.new(i)
      end
    end # === def valid_codepoint?

    def pop
      raise_if_frozen!
      @raw.pop
    end # === def pop

    def all?(r : Range)
      @raw.all? { |x|
        r.includes?(x)
      }
    end # === def all?

    def freeze!
      return self if @frozen
      @frozen = true
      return self
    end

    def print(printer : Printer)
      each { |x| printer.raw! x.chr }
    end # === def print

    module Common

      macro code(char)
        {{char}}.hash
      end # === macro code

      def whitespace?(i : Int32)
        case i
        when code(' '), code('\n')
          true
        else
          false
        end
      end # === def whitespace?

    end # === module Common

    extend Common
    include Common

  end # === class Codepoints

end # === module DA_CSS

