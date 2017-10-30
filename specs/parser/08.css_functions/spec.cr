
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

    should_eq SPEC_PARSER.new(input, __DIR__, :css).to_css, expected
  end # === it "allows rgba(...)"

  it "does not allow expression(...)" do
    input = %[
      div { width: expression(document.width); }
    ]
    expect_raises(DA_STYLE::Parser::Unknown_CSS_Function) {
      SPEC_PARSER.new(input, __DIR__, :css).to_css
    }
  end # === it "does not allow expression(...)"

end # === desc "Parser css functions"
