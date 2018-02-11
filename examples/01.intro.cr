
describe "Example 01: intro" do
  it "renders CSS" do
    assert DA_CSS.to_css("body { color: #fff; }") == "body {\ncolor: #fff;\n}"
  end # === it "renders CSS"

  it "renders example from README.md" do
    blocks = DA_CSS.parse(%[ div { border: 1px solid red; } ])

    blocks.each { |blok| # Deque(DA_CSS::Block)#each
      blok.selectors # Deque(DA_CSS::Selectors
      blok.propertys # Deque(Color_Keyword | Color | A_String | A_Number | ...)

      width = blok.propertys.first.values.first
      case width
      when DA_CSS::Number_Unit
        width.a_number.to_number == 1
        width.unit.token.to_s == "px"
      end
    }

    width = blocks.first.propertys.first.values.first.as(DA_CSS::Number_Unit)

    assert width.a_number.to_number == 1
    assert width.unit.token.to_s == "px"

    assert blocks.first.selectors.first.token.to_s == "div"
    assert blocks.first.propertys.first.key.to_s == "border"
    assert blocks.first.propertys.first.values.first.to_s == "1px"
    assert blocks.first.propertys.first.values.last.to_s == "red"
  end # === it "renders CSS"
end # === desc "Example 01: intro"
