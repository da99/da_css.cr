
class Create_Property
  include DA_STYLE
  create_property "my-prop"
end # === class Create_Property

describe ":create_property" do
  it "renders property" do
    actual = Create_Property.to_css {
      s("body") {
        my_prop px(10)
      }
    }
    should_eq actual, %(
      body {
        my-prop: 10px;
      }
    )
  end # === it "renders property"
end # === desc ":create_property"
