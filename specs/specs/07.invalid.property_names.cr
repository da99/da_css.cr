
describe "Parser invalid property names" do

  it "does not allow: behaviour" do
    input = %[
      body {
         behavior: url('/user/uploadedfiles/file.png');
      }
    ]

    assert_raises(DA_CSS::CSS_Author_Error) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "does not allow: behaviour"

end # === desc "Parser invalid property names"
