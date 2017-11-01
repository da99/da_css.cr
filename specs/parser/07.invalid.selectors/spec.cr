
describe "Parser invalid selectors" do
  it "does not allow [ or ] in the selector" do
    # Security vulnerability:
    #  https://www.curesec.com/blog/article/blog/Reading-Data-via-CSS-Injection-180.html
    input = %[
       #form2 input[value^='a'] { background-image: url(http://localhost/log.php/a); }
    ]

    expect_raises(DA_STYLE::Parser::Invalid_Selector) {
      SPEC_PARSER.new(input, __DIR__).to_css
    }
  end # === it "does not allow [ or ] in the selector"

  it "does not allow = in the selector" do
    input = %[
       #form2 =a { background-image: url('/a'); }
    ]

    expect_raises(DA_STYLE::Parser::Invalid_Selector) {
      SPEC_PARSER.new(input, __DIR__).to_css
    }
  end # === it "does not allow [ or ] in the selector"

  it "does not allow * in the selector" do
    input = %[
       #form2 * div { background-image: url('/a.png'); }
    ]

    expect_raises(DA_STYLE::Parser::Invalid_Selector) {
      SPEC_PARSER.new(input, __DIR__).to_css
    }
  end # === it "does not allow [ or ] in the selector"

  {% for x in %w(* a b) %}
    it "does not allow single character selectors: {{x.id}} { } " do
      input = %[
        {{x.id}} { background-image: url('/local.png'); }
      ]
      expect_raises(DA_STYLE::Parser::Invalid_Selector) {
        SPEC_PARSER.new(input, __DIR__).to_css
      }
    end # === it "does not allow single character selectors: * { } a { } "
  {% end %}
end # === desc "Parser invalid selectors"
