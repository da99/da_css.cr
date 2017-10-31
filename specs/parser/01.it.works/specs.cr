
describe DA_STYLE::Parser do

  it "prints css" do
    should_eq actual!, expected!
  end # === it "works"

  {% for x in system("find specs/parser/samples -maxdepth 1 -type f -name *.css").split("\n").reject(&.empty?) %}
    {% name = x.split("/").last.split(".").first.id %}
    it "renders: {{name}}" do
      input = %[
        div.white {
          #{File.read "{{x.id}}"}
        }
      ]
      actual = SPEC_PARSER.new(input, __DIR__, :css).to_css
      should_eq actual["{{name}}: "], "{{name}}: "
    end # === it "renders "
  {% end %}

end # === desc "DA_STYLE::Parser"
