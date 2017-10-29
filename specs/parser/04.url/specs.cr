
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

end # === desc "Parser url"
