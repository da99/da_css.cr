
class It_Works

  include DA_STYLE
  extend DA_STYLE::HEX

  BLUE  = hex("#E3E0CF")
  GREY  = hex("#908E8E")
  PINK  = hex("#E85669")
  GREEN = hex("#4ab1a8")

  macro col
    width percent(25)
    float left
  end

  create_family "my-box", "width", "height"
  create_family "border-bottom", "style"
  create_family "background", "color"

  create_property "my-prop"
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
  create_property "box-shadow"
  create_property "position"
  create_property "padding"
  create_property "width"
  create_property "float"

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
      border px(10), dotted, hex("white")
      border em(10)
      border_style dotted
      border_color hex("black")
      border_width thick

      border_top_width thick
      border_bottom { style dotted }
      border_radius px(5), percent(5)
      border_radius px(10), percent(5), '/', px(20)
      border_radius px(10), percent(5), '/', px(20), px(30)
      border_radius px(10), percent(5), '/', px(20), px(30), percent(30), em(10)
      box_shadow inherit
      my_prop px(5), px(0), '/', em(-1), 0
      my_box {
        width px(10)
        height px(20)
      }
    }

    to_css
  end

  def self.render
    new.render
  end

end # === Page_Css

it "it works" do
  It_Works.render["border-radius"].should eq("border-radius")
end # === it "it works"


