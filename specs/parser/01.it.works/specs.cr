
describe DA_STYLE::Parser do

  it "prints css" do
    should_eq actual!, expected!
  end # === it "works"

  {% for x in system("find specs/parser/samples -maxdepth 1 -type f -name *.css").split("\n").reject(&.empty?) %}
    {% name = x.split("/").last.split(".").first.id %}
    it "renders: {{name}}" do
      css = begin
              File.read("{{x.id}}")
                .split("\n")
                .reject { |x| x.index("hsla(") }
                .reject { |x| x.index("hsl(") }
                .reject { |x| x.index(/rgb\(.+, .+, .+, .+\)/) }
                .reject { |x| x.index(/rgb\([0-9\ ]+\/[0-9\.\ ]+\)/) }
                .join("\n")
            end
      input = %[
        div.white {
          #{ css }
        }
      ]
      actual = SPEC_PARSER.new(input, __DIR__, :css).to_css
      should_eq actual["{{name}}: "], "{{name}}: "
    end # === it "renders "
  {% end %}

end # === desc "DA_STYLE::Parser"
