
class Create_Family
  include DA_STYLE
  create_family "background", "color", "width"
end # === class Create_Family

describe ":create_family" do
  it "renders multiple properties" do
    actual = Create_Family.to_css {
      s("div.hot") {
        background {
          color hex("red")
          width px(10)
        }
      }
    }
    should_eq actual, %(
      div.hot {
        background-color: #ff0000;
        background-width: 10px;
      }
    )
  end # === it "renders property"
end # === desc ":create_property"
