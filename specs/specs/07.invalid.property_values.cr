
describe "Parser invalid property values" do

  {% for x in system("find specs/sample-errors/ -maxdepth 1 -type f -iname *.css ").split("\n").map(&.strip).reject(&.empty?).sort %}
    {% name = x.split("/").last.split(".css").first %}
    it "raises DA_CSS::CSS_Author_Error for invalid input: {{name.id}}" do
      input = File.read("{{x.id}}")

      assert_raises(DA_CSS::CSS_Author_Error) {
        SPEC_PARSER.to_css(input)
      }
    end # === it "raises Node::Property::Invalid_Value for invalid input: "
  {% end %}


end # === desc "Parser invalid property values"
