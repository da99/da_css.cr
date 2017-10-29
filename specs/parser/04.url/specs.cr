
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

  {% for x in %w(ssh javascript JaVasScript Htp) %}
    it "does not accept urls for {{x.id}}:// in them" do
      input = %[
        div {
          background-image: url('{{x.id}}://remote/image.png');
        }
      ]
      expect_raises(DA_STYLE::Parser::Invalid_URL) {
        DA_STYLE::Parser.new(input, __DIR__, :css).to_css
      }
    end # === it "accepts urls for with ';' in them"
  {% end %}

end # === desc "Parser url"
