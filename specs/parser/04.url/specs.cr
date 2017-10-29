
describe "Parser url" do
  it "accepts local urls" do
    input = %[
      div {
        background-image: url('/local/image.png');
      }
    ]
    actual = DA_STYLE::Parser.new(input, __DIR__, :css).to_css
    should_eq actual, expected!
  end # === it "accepts local urls"

  it "does not accept http:// urls" do
    input = %[
      div {
        background-image: url('http://remote/local/image.png');
      }
    ]
    actual = DA_STYLE::Parser.new(input, __DIR__, :css).to_css
    should_eq actual, input
  end # === it "accepts urls for with ';' in them"

  it "does not accept urls for with ';' in them" do
    input = %[
      div {
        background-image: url('/local/image.png;shoutcast');
      }
    ]
    expect_raises {
      DA_STYLE::Parser.new(input, __DIR__, :css).to_css
    }
  end # === it "accepts urls for with ';' in them"

end # === desc "Parser url"
