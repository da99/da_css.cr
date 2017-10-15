
require "./keyword/keyword"

require "./type/positive_negative"
require "./type/url_image"

require "./type/color"
require "./type/linear_gradient"

require "./type/allowed"

require "./type/length"
require "./type/percent"
require "./type/px"
require "./type/em"
require "./type/angle_degree"
require "./type/zero"

module DA_STYLE

  module Class_Methods
    def render
      style = self.new
      style.render
    end
  end

  macro included
    extend DA_STYLE::Class_Methods
  end

  macro p(name, *args)
    {{name.gsub(/-/, "_").id}}({{ *args }})
  end

  macro create_property(name)
    def {{name.gsub(/-/,"_").id}}(*args)
      write({{name}}, *args)
    end
  end

  macro create_property(name, *args)
    {% klass = name.id.gsub(/\-/, "_").split("_").map { |x| x.capitalize }.join("_") %}
    {% meth = name.downcase.gsub(/\-/, "_") %}

    def {{meth.id}}
      i = {{klass.id}}.new(@io)
      with i yield
    end

    struct {{klass.id}}

      include DA_STYLE::Property

      def initialize(@io : IO::Memory)
      end # === def initialize

      {% for prop in args %}
        def {{prop.id}}(*args)
          write("{{name.gsub(/_/, "-").id}}-{{prop.gsub(/_/, "-").id}}", *args)
        end
      {% end %}
    end # === struct {{klass.id}}
  end # === macro create_property

  macro create_value(name, klass)
    def {{name.id}}(*args)
      {{klass.id}}.new(*args)
    end
  end # === macro create_value

  macro create_value_or_zero(name, klass)
    def {{name.id}}(val)
      if val == 0
        Zero.new
      else
        {{klass.id}}.new(val)
      end
    end
  end # === macro create_value_or_zero

  module Property

    def write(key : String, *args)
      raise Exception.new("No values set for #{key.inspect}") if args.empty?

      @io << "\n  " << key << ":"
      args.map { |x|
        @io << " "
        @io.<<(case x
        when Char
          if !x.ascii? || x.ascii_control? || x.ascii_whitespace?
            raise Exception.new("Invalid value for insertion of a char: #{x.inspect}")
          end
          x
        else
          x.to_css
        end)
      }
      @io << ";"
      return self
    end

  end # === module Property

  include Property

  module Class_Methods
  end # === module Class_Methods

  extend Class_Methods

  @in_nest = false

  def initialize
    @io = IO::Memory.new
  end # === def initialize

  def to_css
    @io.to_s
  end

  def render
    with self yield(self)
  end # === def render

  def s(name : String)
    @io << "\n" << name << " {"
    yield
    @io << " }"

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

  def css
    @io.to_s
  end

end # === module DA_STYLE


