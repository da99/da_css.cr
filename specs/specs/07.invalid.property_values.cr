
describe "Parser invalid property values" do

  it "raises DA_CSS::CSS_Author_Error for unknown values" do
    input = %[
      body { border: xy1; }
    ]

    assert_raises(DA_CSS::CSS_Author_Error) {
      DA_CSS.parse(input)
    }
  end # === it "raises Node::Property::Invalid_Value for invalid input: "


end # === desc "Parser invalid property values"
