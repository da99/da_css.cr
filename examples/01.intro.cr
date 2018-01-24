
describe "Example 01: intro" do
  it "renders CSS" do
    assert DA_CSS.to_css("body { color: #fff; }") == "body {\ncolor: #fff;\n}"
  end # === it "renders CSS"
end # === desc "Example 01: intro"
