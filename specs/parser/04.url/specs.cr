
describe "Parser url" do
  it "accepts local urls" do
    input = %[
      div {
        background-image: url('/local/image.png');
      }
    ]
    actual = SPEC_PARSER.new(input, __DIR__).to_css
    should_eq actual, expected!
  end # === it "accepts local urls"

  it "does not accept urls for with ';' in them" do
    input = %[
      div {
        background-image: url('/local/image.png;shoutcast');
      }
    ]
    expect_raises(DA_STYLE::Parser::Invalid_Property_Value) {
      SPEC_PARSER.new(input, __DIR__).to_css
    }
  end # === it "accepts urls for with ';' in them"

  {% for x in %w(ssh javascript JaVasScript Htp) %}
    it "does not accept urls for {{x.id}}:// in them" do
      input = %[
        div {
          background-image: url('{{x.id}}://remote/image.png');
        }
      ]
      expect_raises(DA_STYLE::Parser::Invalid_Property_Value) {
        SPEC_PARSER.new(input, __DIR__).to_css
      }
    end # === it "accepts urls for with ';' in them"
  {% end %}

  it "does not allow remove urls: http" do
    input = %[
      div { background-image: url('http://remote.com/image.png'); }
    ]

    expect_raises(DA_STYLE::Parser::Invalid_Property_Value) {
      SPEC_PARSER.new(input, __DIR__).to_css
    }
  end # === it "does not allow remove urls: http"

end # === desc "Parser url"
