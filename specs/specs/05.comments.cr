
describe "Parser comments" do
  it "should be removed" do
    input = %[
      /*
       * This is a comment.
       */
      div {
        background-color: #000;
        background-color : #fff; /* is a comment */
        background-color: #ccc ; /*
        another comment */
      }
    ]
    expected = %[
      div {
        background-color: #000;
        background-color: #fff;
        background-color: #ccc;
      }
    ]
    should_eq SPEC_PARSER.to_css(input), strip(expected)
  end # === it "should be removed"
end # === desc "Parser comments"
