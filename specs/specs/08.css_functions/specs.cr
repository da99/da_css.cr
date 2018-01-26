
describe "Parser css functions" do
  it "allows rgba(...)" do
    input = %[
      div { background-color: rgba(0,0,0,0); }
    ]
    expected = %[
      div {
        background-color: rgba(0, 0, 0, 0);
      }
    ]

    should_eq SPEC_PARSER.to_css(input), expected
  end # === it "allows rgba(...)"

  it "does not allow expression(...)" do
    input = %[
      div { width: expression(document.width); }
    ]
    assert_raises(DA_CSS::CSS_Author_Error) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "does not allow expression(...)"

end # === desc "Parser css functions"
