
describe DA_CSS::Printer do

  it "prints css" do
    assert actual! == expected!
  end # === it "works"

  {% for x in system("find specs/samples -maxdepth 1 -type f -name *.css").split("\n").reject(&.empty?) %}
    {% name = x.split("/").last.split(".").first.id %}
    it "renders: {{name}}" do
      css = begin
              File.read("{{x.id}}")
                .split("\n")
                .reject { |x| x.index("hsla(") }
                .reject { |x| x.index("hsl(") }
                .reject { |x| x.index(/rgb\(.+, .+, .+, .+\)/) }
                .reject { |x| x.index(/rgb\([0-9\ ]+\/[0-9\.\ ]+\)/) }
                .reject { |x| x.index(/^cursor: url\(/) }
                .reject { |x| x.index(/^border: [^\s]+( [^\s]+)?;$/) }
                .join("\n")
            end

      case "{{name}}"
      when "font-family"
        css = css.gsub(/: ([^",;]+),/, ": \"\\1\",")
          .split("\n")
          .reject { |x| x.index(/Grande|@/) }
          .join("\n")
      end

      input = %[ div.white {\n#{ css }\n } ]
      actual = SPEC_PARSER.to_css(input)
      should_eq actual["{{name}}: "], "{{name}}: "
    end # === it "renders "
  {% end %}

end # === desc "DA_CSS::Printer"
