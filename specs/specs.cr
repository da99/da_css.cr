
require "../src/style"
module Style
  include Keywords
end # === module Style

require "../src/property/background"
require "../src/property/border"
require "../src/property/box_shadow"

class Page_Css

  include Style
  include Style::Keywords

  module Class_Methods

    def hex(s : String)
      Hex_Color.new(s)
    end

  end # === module Class_methods

  extend Class_Methods

  BLUE  = hex("#E3E0CF")
  GREY  = hex("#908E8E")
  PINK  = hex("#E85669")
  GREEN = hex("#4ab1a8")

  create_property "background-color"
  create_property "padding"
  create_property "width"
  create_property "float"

  macro col
    width percent(25)
    float left
  end

  def render

    # s_alias (means: selector alias)
    # s       (means: selector)

    s_alias("div") { |x|
      s(x) { background_color BLUE }
      s("#{x} span") { padding px(10) }
    }

    s("body") {
      background {
        color GREY
      }
    }

    s("#number") { col }
    s("#words") { col; background_color PINK }
    s("#quotation") { col; background_color GREEN }

    to_css
  end

end

puts Page_Css.render

class Spec_Css

  include Style
  include Style::Keywords

  BLUE = "#E3E0CF"
  GREY = "#908E8E"
  PINK = "#E85669"
  GREEN = "#4ab1a8"

  macro col
    width percent(25)
    float left
  end

  create_property "my-prop"
  create_property "my-box", "width", "height"
  create_property "padding"
  create_property "width"
  create_property "float"

  def z(i)
    if i != 0
      raise Exception.new("Only zero allowed.: #{i.inspect}")
    end
    return Allowed.new(i)
  end # === def z

  def render

    s_alias("div") { |x|
      s(x) { background_color BLUE }
      s("#{x} span") { padding em(0.8) }
    }

    s("body") {
      background { color GREY }
      background_image url("./image.png")
      background_position top

      background {
        position top
      }
      background_repeat no_repeat
      # background_position bottom
    }

    s("#number") { col }
    s("#words") { col; background_color PINK }
    s("#quotation") { col; background_color GREEN }

    s("div") {
      border px(10), dotted, Hex_Color.new("white")
      border em(10)
      border_style dotted
      border_color Hex_Color.new("black")
      border_width thick

      border_top_width thick
      border_bottom { style dotted }
      border_bottom_left_radius inherit
      border_top_right_radius px(5)
      border_radius px(5), percent(5)
      border_radius px(10), percent(5), '/', px(20)
      border_radius px(10), percent(5), '/', px(20), px(30)
      border_radius px(10), percent(5), '/', px(20), px(30), percent(30), em(10)
      box_shadow inherit
      my_prop px(5), px(0), '/', em(-1), z(0)
      my_box {
        width px(10)
        height px(20)
      }
    }

    to_css
  end

end # === Page_Css

puts Spec_Css.render
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

