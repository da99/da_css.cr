
module DA_CSS
  struct Printer

    getter io_css = IO_CSS.new

    def self.to_css(raw_doc)
      new.to_css(raw_doc)
    end # === def self.to_css

    def raw!(*args)
      @io_css.raw! *args
    end # === def raw!

    def new_line
      @io_css.raw! "\n" unless @io_css.empty?
      self
    end # === def new_line

    def to_css(nodes)
      nodes.each { |x| x.to_s(@io_css) } if @io_css.empty?
      io_css.to_s
    end # === def to_css

    def write(x : Node::Property)
      io_css.indent
      x.key.to_css(io_css)
      io_css.raw! ": "
      x.value.to_css(io_css)
      io_css.raw! ";\n"
      self
    end # === def write_property

    def write(x : Node::Selector_With_Body)
      io_css.indent
      x.head.each { |x| io_css.raw! x.chr }
      io_css.raw! " {\n"
      io_css.indent {
        Printer.new(self, x.body).to_css
      }
      io_css.indent
      io_css.raw! "}\n"
      self
    end # === def write

  end # === class Printer
end # === module DA_CSS
