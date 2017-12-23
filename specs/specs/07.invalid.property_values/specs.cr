
describe "Parser invalid property values" do

  {% for x in system("find specs/sample-errors/ -maxdepth 1 -type f -iname *.css ").split("\n").map(&.strip).reject(&.empty?) %}
    {% name = x.split("/").last.split(".css").first %}
    it "raises Node::Property::Invalid_Value for invalid input: {{name.id}}" do
      input = %[
        div.white {
          #{File.read("{{x.id}}")}
        }
      ]

      expect_raises(DA_CSS::Node::Property::Invalid_Value) {
        SPEC_PARSER.to_css(input)
      }
    end # === it "raises Node::Property::Invalid_Value for invalid input: "
  {% end %}

  {% for x in system("find specs/samples/ -maxdepth 1 -type f -iname *.css ").split("\n").map(&.strip).reject(&.empty?) %}
    {% name = x.split("/").last.split(".css").first %}
      File.read("{{x.id}}").split("\n").map { |x|
        x.sub(/;/, " * % @ ;")
      }.reject { |x|
        x =~ /^\// || x.strip.empty?
      }.each { |line|
        it "raises Node::Property::Invalid_Value unknown characters mixed with valid: #{line}" do
          input = %[ div.white { #{line} } ]

          expect_raises(DA_CSS::Node::Property::Invalid_Value) {
            SPEC_PARSER.to_css(input)
          }
        end # === it "raises Node::Property::Invalid_Value for invalid input: "
      }
  {% end %}

end # === desc "Parser invalid property values"
