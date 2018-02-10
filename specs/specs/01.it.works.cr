
describe "Parser" do
  it "returns a Deque(DA_CSS::Block)" do
    input = %[
      body {
        border: none;
      }
    ]

    actual = DA_CSS.parse(input)

    blok = actual.first
    assert blok.selectors.first.to_s == "body"

    p = blok.propertys.first
    assert p.key.to_s == "border"
    assert p.values.first.to_s == "none"
    assert p.values.first.is_a?(DA_CSS::Keyword) == true
  end # === it "returns a Deque(DA_CSS::Block)"
end # === desc "Parser"
