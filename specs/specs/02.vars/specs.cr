
describe "Parser vars" do
  it "does not allow invalid characters in final replacement" do
    input = %[
      BLACK = ~~~~ ;
      div { background-color: {{BLACK}} ; }
    ]

    expect_raises(DA_CSS::Node::Property::Invalid_Value) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "does not allow invalid characters in final replacement"
end # === desc "Parser vars"
