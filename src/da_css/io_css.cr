
module DA_CSS

  class IO_CSS

    @parent_count : Int32 = 0
    @io : IO::Memory = IO::Memory.new

    def initialize
    end # === def initialize

    def initialize(@parent_count)
    end # === def initialize

    def raw!(*strings)
      strings.each { |x|
        case x
        when String, Char
          @io << x
        else
          raise Exception.new("Invalid string: #{x.inspect}")
        end
      }
    end # === def raw!

    def empty?
      @io.empty?
    end # === def empty?

    def to_s
      @io.to_s
    end # === def to_s

  end # === class IO_CSS

end # === module DA_CSS
