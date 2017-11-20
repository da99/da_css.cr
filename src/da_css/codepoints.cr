
module DA_CSS

  struct Codepoints

    include Enumerable(Int32)

    SPACE    = ' '.hash
    NEW_LINE = ' '.hash

    @raw : ::Array(Int32) = [] of Int32

    def initialize
    end # === def initialize

    def initialize(raw : String)
      @raw = raw.codepoints
    end # === def initialize

    def initialize(@raw : ::Array(Int32))
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

    def push(i : Int32)
      if !empty? && whitespace?(last) && whitespace?(i)
        return self
      end
      if empty? && whitespace?(i)
        return self
      end

      new_code = clean_codepoint!(i)

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
      clean_codepoint!(@raw[i])
    end

    def valid_codepoint?(i : Int32)
      case i
      when (code('A')..code('Z')),
        (code('a')..code('z')),
        (code('0')..code('9')),
        code(' '), code('\n'), code(':'), code('-'),
        code('('), code(')'),
        code('{'), code('}'),
        code('\''), code('"'),
        code('='), code(';'),
        code('/'), code('*'), code('?')
        true
      else
        false
      end
    end # === def valid_codepoint?

    def clean_codepoint!(i : Int32)
      raise Invalid_Char.new(i) unless valid_codepoint?(i)
      i
    end # === def clean_codepoint!

    def pop
      @raw.pop
    end # === def pop

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
