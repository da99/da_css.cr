

require "../src/style"

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
      s(x) { background_color BLUE }
      s("#{x} span") { padding 0.8.em }
    }

    s("body") {
      background { color GREY }
      background_image url("./image.png")
      # background { position top }
      background_position top
      background_repeat no_repeat
      # background_position bottom
    }

    s("#number") { col }
    s("#words") { col; background_color PINK }
    s("#quotation") { col; background_color GREEN }

    s("div") {
      border 10.px, dotted, Hex_Color.new("white")
      border 10.em
      border_style dotted
      border_color Hex_Color.new("black")
      border_width thick

      border_top_width thick
      border_bottom { style dotted }
      border_bottom_left_radius inherit
      border_top_right_radius 5.px
      border_radius 5.px, 5.percent
      border_radius 10.px, 5.percent, '/', 20.px
      border_radius 10.px, 5.percent, '/', 20.px, 30.px
      border_radius 10.px, 5.percent, '/', 20.px, 30.px, 30.percent, 10.em
      box_shadow inherit

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

