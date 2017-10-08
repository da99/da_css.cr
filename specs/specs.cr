
require "../src/style"
require "../src/type/url_image"

module Style
  include Keywords
end # === module Style


class Spec_Css

  include Style
  include Style::Keywords

  BLUE  = Hex_Color.new("#E3E0CF")
  GREY  = Hex_Color.new("#908E8E")
  PINK  = Hex_Color.new("#E85669")
  GREEN = Hex_Color.new("#4ab1a8")

  macro col
    width percent(25)
    float left
  end

  create_property "my-prop"
  create_property "my-box", "width", "height"
  create_property "background", "color"
  create_property "background-color"
  create_property "background-image"
  create_property "background-position"
  create_property "background-repeat"
  create_property "border"
  create_property "border-style"
  create_property "border-color"
  create_property "border-width"
  create_property "border-top-width"
  create_property "border-radius"
  create_property "border-bottom", "style"
  create_property "box-shadow"
  create_property "position"
  create_property "padding"
  create_property "width"
  create_property "float"

  create_value "z", Zero
  create_value_or_zero "em", Em
  create_value_or_zero "px", Px
  create_value_or_zero "percent", Percent

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
      background_position bottom
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

