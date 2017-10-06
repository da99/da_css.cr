
struct Int32

  def percent
    Style::Percent.new(self)
  end

  def px
    Style::PX.new(self)
  end # === def px

  def em
    Style::EM.new(self)
  end

end # === class Int32

module Style

  alias Size = Percent | PX

  struct EM
    def initialize(num : Int32)
      if num < 0 || num > 10
        raise Exception.new("Value out of range for .em: #{num.inspect}")
      end
      @val = num
    end # === def initialize

    def value
      "#{@val}em"
    end # === def value
  end # === class PX

  struct Percent
    def initialize(num : Int32)
      @val = num
    end # === def initialize

    def value
      "#{@val}%"
    end # === def value
  end # === class PX

  struct PX

    def initialize(num : Int32)
      @val = num
    end # === def initialize

    def value
      "#{@val}px"
    end # === def value

  end # === class PX

  struct Color

    def initialize(val : String)
      if !val.match(/^#[a-zA-Z0-9]+$/)
        raise Exception.new("Invalid color: #{val}")
      end

      @val = val
    end # === def initialize

    def value
      @val
    end # === def value

  end # === class Color

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
    {{name.gsub(/-/, "_").id}}({{args.map { |x| x.id }.join(", ").id}})
  end

  @in_nest = false

  def initialize
    @content = IO::Memory.new
  end # === def initialize

  def to_css
    @content.to_s
  end

  def render
    with self yield(self)
  end # === def render

  def s(name : String)
    @content << "\n" << name << " {"
    with self yield
    @content << " }"

    return self
  end

  def s_alias(name : String)
    raise Exception.new("Nesting of :rename not allowed.") if @in_nest
    @in_nest = true
    with self yield(name)
    @in_nest = false
    return self
  end

  def percent(num : Int32)
    Percent.new(num)
  end # === def percent

  def width(quantity : Size)
    @content << " width: #{quantity.value}; "
  end # === def width

  def float(dir : String)
    case
    when "left", "right", "none", "inline-start", "inline-end", "inherit", "initial", "unset"
      @content << " float: #{dir}; "
    else
      raise Exception.new("Invalid float value: #{dir.inspect}")
    end
  end # === def float

  def background(color : Color | String)
    case color
    when String
      color = Color.new(color)
    end
    @content << " background: " << color.value << ";"

    return self
  end

  def padding(px : PX)
    @content << " padding: " << px.value << ";"
  end # === def padding

  def px(num : Int32)
    PX.new(num)
  end

  def css
    @content.to_s
  end

end # === module Style

class Page_Css

  include Style
  BLUE = "#E3E0CF"
  GREY = "#908E8E"
  PINK = "#E85669"
  GREEN = "#4ab1a8"

  macro col
    width 25.percent
    float "left"
  end

  def render

    s_alias("div") { |x|
      s(x) { background BLUE }
      s("#{x} span") { padding 10.px }
    }

    s("body") {
      background GREY
    }

    s("#number") { col }
    s("#words") { col; background PINK }
    s("#quotation") { col; background GREEN }

    to_css
  end

end

css = Page_Css.render

puts css
# div {
#   background: #E3E0CF;
#   margin: 10px;
#   padding: 10px;
# }

# div span {
#  padding: 10px;
# }

# body {
#   background: #908E8E;
# }


# #number {
#   width: 25%;
#   float: left;
# }

# #words {
#   width: 25%;
#   float: left;
#   background: #E85669;
# }

# #quotation {
#   width: 25%;
#   float: left;
#   background: #4ab1a8;
# }

