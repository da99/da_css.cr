
describe "Parser vars" do
  it "does not allow invalid characters in final replacement" do
    input = %[
      BLACK = ~~~~ ;
      div { background-color: {{BLACK}} ; }
    ]

    expect_raises(DA_CSS::Invalid_Property_Value) {
      SPEC_PARSER.new(input, __DIR__).to_css
    }
  end # === it "does not allow invalid characters in final replacement"
end # === desc "Parser vars"
