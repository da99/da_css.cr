
describe "Parser invalid property names" do
  it "does not allow: behaviour" do
    input = %[
      body {
         behavior: url('/user/uploadedfiles/file.png');
      }
    ]

    expect_raises(DA_CSS::Node::Property::Invalid_Name) {
      SPEC_PARSER.to_css(input)
    }
  end # === it "does not allow: behaviour"

  {% for x in system("cat \"#{__DIR__}/../../../src/da_css/familys.txt\"").split("\n").reject(&.empty?).map(&.split.first) %}
    {% if !%w(padding border margin).includes?(x) %}
      it "does not allow family names as property names: {{x.id}}" do
        input = %[
          div { {{x.id}}: none; }
        ]
        expect_raises(DA_CSS::Node::Property::Invalid_Name) {
          SPEC_PARSER.to_css(input)
        }
      end # === it "does not allow family names as property names:"
    {% end %}
  {% end %}
end # === desc "Parser invalid property names"
