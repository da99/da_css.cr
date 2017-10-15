
require "./keyword/*"
require "./type/*"

module DA_STYLE

  include DA_STYLE::Keywords
  include DA_STYLE::PX
  include DA_STYLE::EM
  include DA_STYLE::PERCENT
  include DA_STYLE::URL

  macro included
    def self.to_css
      s = new
      with s yield
      s.to_css
    end
  end

  macro p(name, *args)
    {{name.gsub(/-/, "_").id}}({{ *args }})
  end

  macro create_property(name)
    def {{name.gsub(/-/,"_").id}}(*args)
      io.write_property({{name}}, *args)
    end
  end

  macro create_family(name, *args)
    {% klass = name.id.gsub(/\-/, "_").split("_").map { |x| x.upcase }.join("_") + "_FAMILY" %}
    {% meth = name.downcase.gsub(/\-/, "_") %}

    def {{meth.id}}
      i = {{klass.id}}.new(io)
      with i yield
    end

    struct {{klass.id}}

      getter :io
      def initialize(@io : DA_STYLE::INPUT_OUTPUT)
      end # === def initialize

      {% for prop in args %}
        def {{prop.id}}(*args)
          io.write_property("{{name.gsub(/_/, "-").id}}-{{prop.gsub(/_/, "-").id}}", *args)
        end
      {% end %}

    end # === struct {{klass.id}}

  end # === macro create_property

  class INPUT_OUTPUT

    def initialize
      @io__ = IO::Memory.new
    end # === def initialize

    def write_property(s : String, *vals)
      return self if vals.empty?
      raw! s, ":"
      vals.each { |v|
        raw! " ", v
      }
      raw! ";"
      self
    end # === def write_property

    def raw!(*args)
      args.each { |x|
        case x
        when String
          @io__ << x
        when Int32
          @io__ << x
        when Float64
          @io__ << x
        when Char
          if !x.ascii? || x.ascii_control? || x.ascii_whitespace?
            raise Exception.new("Invalid value for insertion of a char: #{x.inspect}")
          end
          @io__ << x
        else
          x.write_to(self)
        end
      }
      self
    end # === def raw!

    def to_css
      @io__.to_s
    end # === def to_css

  end # === class STANDARD_INPUT_OUTPUT

  def to_css
    @io.to_s
  end

  def render
    with self yield(self)
  end # === def render

  def s(name : String)
    io.raw! "\n", name, " {\n"
    yield
    io.raw! "\n}"

    return self
  end

  def s_alias(name : String)
    raise Exception.new("Nesting of :rename not allowed.") if @in_nest
    @in_nest = true
    yield(name)
    @in_nest = false
    return self
  end

  def scoped(klass)
    i = klass.new(@io)
    with i yield
  end

  def initialize
    @io = DA_STYLE::INPUT_OUTPUT.new
    @in_nest = false
  end # === def initialize

  def io
    @io
  end # === def io

  def to_css
    io.to_css
  end

end # === module DA_STYLE


