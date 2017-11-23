
module DA_CSS

  class Printer

    getter parent : Printer? = nil
    getter doc : Doc
    getter io_css : IO_CSS = IO_CSS.new
    getter data = {} of String => String
    @is_done = false
    @parent_count = 0

    def initialize(@doc)
    end # === def initialize

    def initialize(@parent : Printer, @doc)
      @parent_count += 1
      parent = @parent
      if parent
        @io_css = parent.io_css
      end
    end # === def initialize

    def run
      doc.nodes.each { |x|
        case x
        when Node::Comment
          {% begin %}
            {% if env("IS_DEV") %}
              puts "Ignoring comment: #{x.to_s.inspect}"
            {% end %}
          {% end %}

        when Node::Statement
          raise Exception.new("Invalid expression: #{x.to_s}")

        when Node::Text
          raise Node::Invalid_Text.new(x.to_s.inspect)

        when Node::Assignment
          data[x.string_name] = x.string_value

        when Node::Function_Call
          raise Exception.new("Function can go here.")

        when Node::Property, Node::Selector_With_Body
          write(x)

        else
          raise Exception.new("Invalid value: #{x.to_s.inspect}")
        end
      }
      @is_done = true
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
