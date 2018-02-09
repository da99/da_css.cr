
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

  it "does not accept urls for with ';' in them" do
    input = %[
      div {
        background-image: url('/local/image.png;shoutcast');
      }
    ]
    assert_raises(DA_CSS::CSS_Author_Error) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "accepts urls for with ';' in them"

  {% for x in %w(ssh javascript JaVasScript Htp) %}
    it "does not accept urls for {{x.id}}:// in them" do
      input = %[
        div {
          background-image: url('{{x.id}}://remote/image.png');
        }
      ]
      assert_raises(DA_CSS::CSS_Author_Error) {
        SPEC_PARSER.to_css(input)
      }
    end # === it "accepts urls for with ';' in them"
  {% end %}

  it "does not allow remove urls: http" do
    input = %[
      div { background-image: url('http://remote.com/image.png'); }
    ]

    assert_raises(DA_CSS::CSS_Author_Error) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "does not allow remove urls: http"

end # === desc "Parser url"
