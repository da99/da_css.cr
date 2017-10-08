
require "../src/style"

require "../src/property/background"
require "../src/property/border"
require "../src/property/width"
require "../src/property/float"
require "../src/property/padding"
require "../src/property/box_shadow"

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

  create_property "my-prop"

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
    }

    to_css
  end

end # === Page_Css

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

