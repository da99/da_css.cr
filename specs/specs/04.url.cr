
describe "Parser url" do

  it "accepts local urls" do
    input = %[
      div {
        background-image: url('/local/image.png');
      }
    ]
    actual = SPEC_PARSER.to_css(input)
    assert actual == strip_each_line(%[
      div {
        background-image: url('/local/image.png');
      }
    ])
  end # === it "accepts local urls"

end # === desc "Parser url"
