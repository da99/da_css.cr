
module DA_CSS
  class Printer

    getter parent    : Printer? = nil
    getter doc       : Parser
    getter io_css    : IO_CSS = IO_CSS.new
    getter validator : DA_CSS::Validator

    getter data = {} of String => String
    @is_done = false
    @parent_count = 0

    def initialize(raw : String, @validator)
      @doc = Parser.new(raw).parse
    end # === def initialize

    def initialize(parent : Printer, @doc)
      @parent_count += 1
      @parent    = parent
      @validator = parent.validator
      @io_css    = parent.io_css
    end # === def initialize

    def raw!(*args)
      @io_css.raw! *args
    end # === def raw!

    def new_line
      @io_css.raw! "\n" unless @io_css.empty?
      self
    end # === def new_line

    def new_line(parent : Parser)
      @io_css.raw! "\n" unless @io_css.empty?
      # parent.parent_count.times do |i|
      #   @io_css.raw! "  "
      # end
      self
    end # === def new_line

    def run
      doc.nodes.each_with_index { |x, pos|
        status = validator.allow(x)
        case status
        when false
          raise Exception.new("Invalid value: #{x.to_s.inspect}")
        when :ignore
          next
        end

        x.print(self)
      }
      @is_done = true
      self
    end # === def run

    def to_css
      run unless @is_done
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
