
describe "Parser invalid property values" do

  {% for x in system("find specs/parser/sample-errors/ -maxdepth 1 -type f -iname *.css ").split("\n").map(&.strip).reject(&.empty?) %}
    {% name = x.split("/").last.split(".css").first %}
    it "raises Invalid_Property_Value for invalid input: {{name.id}}" do
      input = %[
        div.white {
          #{File.read("{{x.id}}")}
        }
      ]

      expect_raises(DA_STYLE::Parser::Invalid_Property_Value) {
        SPEC_PARSER.new(input, __DIR__).to_css
      }
    end # === it "raises Invalid_Property_Value for invalid input: "
  {% end %}

  {% for x in system("find specs/parser/samples/ -maxdepth 1 -type f -iname *.css ").split("\n").map(&.strip).reject(&.empty?) %}
    {% name = x.split("/").last.split(".css").first %}
      File.read("{{x.id}}").split("\n").map { |x|
        x.sub(/;/, " * % @ ;")
      }.reject { |x|
        x =~ /^\// || x.strip.empty?
      }.each { |line|
        it "raises Invalid_Property_Value unknown characters mixed with valid: #{line}" do
          input = %[ div.white { #{line} } ]

          expect_raises(DA_STYLE::Parser::Invalid_Property_Value) {
            SPEC_PARSER.new(input, __DIR__).to_css
          }
        end # === it "raises Invalid_Property_Value for invalid input: "
      }
  {% end %}

end # === desc "Parser invalid property values"
