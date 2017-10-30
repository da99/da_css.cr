
describe "Parser invalid property names" do
  it "does not allow: behaviour" do
    input = %[
      body {
         behavior: url('/user/uploadedfiles/file.png');
      }
    ]

    expect_raises(DA_STYLE::Parser::Invalid_Property_Name) {
      SPEC_PARSER.new(input, __DIR__, :css).to_css
    }
  end # === it "does not allow: behaviour"
end # === desc "Parser invalid property names"
