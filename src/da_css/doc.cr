
module DA_CSS

  struct Doc

    alias TYPES =
      Node::Text | Node::Assignment |
      Node::Selector_With_Body | Node::Comment |
      Node::Property | Node::Function_Call | Node::Color |
      Node::Keyword | Node::Property | Node::Number | Node::Number_Unit |
      Node::Percentage | Node::Slash | Node::Unknown

    include Enumerable(TYPES)
    getter nodes = [] of TYPES

    def each
      nodes.each { |x| yield x }
    end # === def each

    def push(node)
      @nodes << node
    end # === def push

    def inspect(io)
      io << "Doc["
      nodes.each_with_index { |x, i|
        io << ", " unless i == 0
        x.inspect(io)
      }
      "]"
    end # === def inspect

    def print(printer : Printer)
      @nodes.each_with_index { |x, i|
        printer.raw! " " if i != 0
        x.print(printer)
      }
      self
    end # === def print

    def first
      @nodes.first
    end # === def first

    def last
      @nodes.last
    end

    def empty?
      @nodes.empty?
    end # === def empty?

    def first_and_only(err_msg)
      return first if @nodes.size == 1
      raise Exception.new(err_msg)
    end # === def first_and_only

    def to_s
      io = IO::Memory.new
      nodes.each_with_index { |x, i|
        io << ' ' if i != 0
        io << x.to_s
      }
      io.to_s
    end # === def to_s

  end # === struct Doc

end # === module DA_CSS
