
require "./keyword/*"
require "./type/*"

module DA_STYLE

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
      i = {{klass.id}}.new(@io)
      with i yield
    end


    struct {{klass.id}}

      getter :io
      def initialize(@io : DA_STYLE::INPUT_OUTPUT)
      end # === def initialize

      {% for prop in args %}
        def {{prop.id}}(*args)
          write("{{name.gsub(/_/, "-").id}}-{{prop.gsub(/_/, "-").id}}", *args)
        end
      {% end %}

      def write(key : String, *args)
        raise Exception.new("No values set for #{key.inspect}") if args.empty?

        io.raw!("\n  ", key, ":")
        args.map { |x|
          io.raw! " "
          @io.raw!(
            case x
          when Char
            if !x.ascii? || x.ascii_control? || x.ascii_whitespace?
              raise Exception.new("Invalid value for insertion of a char: #{x.inspect}")
            end
            x
          else
            x.to_css
          end
          )
        }
        io.raw! ";"
        return self
      end
    end # === struct {{klass.id}}
  end # === macro create_property

  class VALUE

    def initialize(@value : String)
    end # === def initialize

    def to_css
      @value
    end # === def to_css

  end # === class VALUE
  class INPUT_OUTPUT

    def initialize
      @io__ = IO::Memory.new
    end # === def initialize

    def write_property(s : String, *vals)
      return self if vals.empty?
      raw! s, ": "
      raw! vals.map { |v|
        case v
        when Char
          v
        else
          v.to_css
        end
      }.join(" ")
      raw! ";"
      self
    end # === def write_property

    def raw!(*args)
      args.each { |s|
        case s
        when String
          @io__ << s
        else
          raise Exception.new("Invalid value for io: #{s.inspect}")
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


