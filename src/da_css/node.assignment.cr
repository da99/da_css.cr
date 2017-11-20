module Node

  struct Assignment

    getter name  : Codepoints
    getter value : Codepoints::Array

    def initialize(@name, @value)
    end # === def initialize

    def string_name
      name.to_s
    end # === def string_name

    def string_value
      io = IO::Memory.new
      @value.each_with_index { |arr, i|
        io << ' ' if i != 0
        arr.each { |x|
          io << x
        }
      }
      io.to_s
    end # === def string_value

  end # === struct Assignment

end # === module Node
