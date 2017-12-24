
module DA_CSS
  struct Printer

    def self.to_css(raw_doc)
      new.to_css(raw_doc)
    end # === def self.to_css

    @io = IO::Memory.new
    delegate empty?, to: @io

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

    def to_css(nodes)
      nodes.each { |x| x.to_s(self) } if self.empty?
      to_s
    end # === def to_css

  end # === class Printer
end # === module DA_CSS
