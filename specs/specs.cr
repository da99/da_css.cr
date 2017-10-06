
module Style

  alias Size = Percent | PX

  struct Percent
    def initialize(num : Int32 | Int64)
      @val = num
    end # === def initialize

    def value
      "#{@val}%"
    end # === def value
  end # === class PX

  struct PX

    def initialize(num : Int32 | Int64)
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

    def initialize
      @content = IO::Memory.new
    end # === def initialize

    def to_css
      @content.to_s
    end

    def render
      with self yield(self)
    end # === def render

    def __(name : String)
      @content << "\n" << name << " {"
      with self yield
      @content << " }"

      return self
    end

    def nest(name : String)
      with self yield(name)
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
    width percent(25)
    float "left"
  end

  def render

    nest("div") { |x|
      __(x) { background BLUE }
      __("#{x} span") { padding px(10) }
    }

    __("body") {
      background GREY
    }

    __("#number") { col }
    __("#words") { col; background PINK }
    __("#quotation") { col; background GREEN }

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

