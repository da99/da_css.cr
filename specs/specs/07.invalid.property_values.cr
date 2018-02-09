
describe "Parser invalid property values" do

  it "raises DA_CSS::CSS_Author_Error for: 10vpi" do
    input = %[
      body { border: 10vpi; }
    ]

    assert_raises(DA_CSS::CSS_Author_Error) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "raises Node::Property::Invalid_Value for invalid input: "


end # === desc "Parser invalid property values"
