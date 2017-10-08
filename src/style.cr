
require "./keyword/keyword"

require "./type/positive_negative"
require "./type/url_image"
require "./type/percent"
require "./type/px"
require "./type/em"
require "./type/color"
require "./type/linear_gradient"
require "./type/angle_degree"
require "./type/float64"
require "./type/length"
require "./type/allowed"
require "./type/zero"

module Style

  module Class_Methods
    def render
      style = self.new
      style.render
    end
  end

  macro included
    extend Style::Class_Methods
  end

  macro p(name, *args)
    {{name.gsub(/-/, "_").id}}({{ *args }})
  end

  macro create_property(name)
    def {{name.gsub(/-/,"_").id}}(*args)
      write({{name}}, *args)
    end
  end

  module Property

    def write(key : String, *args)
      if args.empty?
        raise Exception.new("No values set for #{key.inspect}")
      end
      @io << "  " << key << ":"
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
      @io << ";\n"
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
    with self yield
    @io << " }"

    return self
  end

  def s_alias(name : String)
    raise Exception.new("Nesting of :rename not allowed.") if @in_nest
    @in_nest = true
    with self yield(name)
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

end # === module Style
