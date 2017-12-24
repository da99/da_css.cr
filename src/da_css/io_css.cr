
module DA_CSS

  class IO_CSS

    @io = IO::Memory.new
    delegate empty?, to: @io

    def initialize
    end # === def initialize

    def <<(x : String | Char)
      case x
      when String, Char
        @io << x
      else
        raise Exception.new("Invalid string: #{x.inspect}")
      end
      self
    end # === def raw!

    def to_s(*args)
      @io.to_s(*args)
    end # === def to_s

  end # === class IO_CSS

end # === module DA_CSS
