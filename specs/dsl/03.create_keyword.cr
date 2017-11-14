
class Create_Keyword
  include DA_CSS::DSL
  create_keyword "to_the_top", "to the top"
  create_property "direction"
end # === class Create_Keyword

describe ":create_keyword" do
  it "renders keyword" do
    actual = Create_Keyword.to_css {
      s("div.box") { direction to_the_top }
    }
    should_eq actual, %(
      div.box {
        direction: to the top;
      }
    )
  end # === it "renders keyword"
end # === desc ":create_keyword"
