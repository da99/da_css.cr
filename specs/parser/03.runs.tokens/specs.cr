
describe "DA_STYLE::Parser" do
  it "runs tokens" do
    tokens =[
      "-webkit-border-radius:", "{{RADIUS1}};",
      "-moz-border-radius:", "{{RADIUS1}};",
      "-ms-border-radius:", "{{RADIUS2}};",
      "border-radius:", "{{RADIUS2}};",
      "background", "{", "color:", "#fff;", "}"
    ]
    vars = {"RADIUS1" => "1em", "RADIUS2" => "2em"}

    actual = DA_STYLE::Parser.new(tokens, vars, __DIR__).to_css
    should_eq actual, File.read("#{__DIR__}/expected.css")
  end # === it "runs tokens"
end # === desc "DA_STYLE::Parser"