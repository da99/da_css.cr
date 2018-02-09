
describe "Parser selector invalid characters" do

  it "does not allow * in the selector" do
    input = %[
       #form2 * div { background-image: url('/a.png'); }
    ]

    assert_raises(DA_CSS::CSS_Author_Error) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "does not allow [ or ] in the selector"

  {% for x in %w(* & %) %}
    it "does not allow single character selectors: {{x.id}} { } " do
      input = %[
        {{x.id}} { border: 1px; }
      ]
      assert_raises(DA_CSS::CSS_Author_Error) {
        SPEC_PARSER.to_css(input)
      }
    end # === it "does not allow single character selectors: * { } a { } "
  {% end %}

end # === desc "Parser selector invalid characters"
