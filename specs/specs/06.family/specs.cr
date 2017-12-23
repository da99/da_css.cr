
describe "Parser property family" do
  it "combines them to a single line" do
    input = %[
      div {
        margin {
         left: 1em;
         right: 2em;
        }
        outline {
          color: #fff;
          style: dashed;
        }
      }
    ]
    expected = %[
      div {
        margin-left: 1em;
        margin-right: 2em;
        outline-color: #fff;
        outline-style: dashed;
      }
    ]
    should_eq SPEC_PARSER.to_css(input), expected
  end # === it "combines them to a single line"

  it "combines deeply nested values" do
    input = %[
      div {
        border {
          left { color: #fff; }
          style: dashed;
          bottom {
            style: dashed;
          } } }
    ]
    expected = %[
      div {
        border-left-color: #fff;
        border-style: dashed;
        border-bottom-style: dashed;
      }
    ]
    should_eq SPEC_PARSER.to_css(input), expected
  end # === it "combines deeply nested values"

end # === desc "Parser property family"
