
describe "Parser: include" do

  it "runs the code of the target file" do
    file     = File.read(__DIR__ + "/01.file1.css")
    expected = File.read(__DIR__ + "/01.expected.css")
    actual   = SPEC_PARSER.new(file, __DIR__).to_css
    should_eq expected, actual
  end # === it "runs the code of the target file"

  it "runs the included code in the same scope" do
    input = %(
      include("./02.colors.css");
      div { color: {{WHITE1}}; }
      div { color: {{WHITE2}}; }
    )
    expected = %(
      div {
        color: #fff;
      }
      div {
        color: #ffffff;
      }
    )
    actual = SPEC_PARSER.new(input, __DIR__).to_css
    should_eq actual, expected
  end # === it "runs the included code in the same scope"

end # === desc "Parser: include"
