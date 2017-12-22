
module DA_CSS
  class Printer

    getter io_css    : IO_CSS = IO_CSS.new
    getter validator : DA_CSS::Validator

    getter nodes = Deque(Raw_Media_Query | Raw_Blok).new
    @done = false

    def initialize(raw : String, @validator)
      @origin = Origin.new(raw)
      @nodes = @origin.parse
    end # === def initialize

    def raw!(*args)
      @io_css.raw! *args
    end # === def raw!

    def new_line
      @io_css.raw! "\n" unless @io_css.empty?
      self
    end # === def new_line

    def run
      nodes.each_with_index { |x, pos|
        status = validator.allow(x)
        case status
        when false
          raise Error.new("Invalid value: #{x.to_s.inspect}")
        when :ignore
          next
        end

        x.print(self)
      }
      @done = true
      self
    end # === def run

    def to_css
      run unless @done
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
