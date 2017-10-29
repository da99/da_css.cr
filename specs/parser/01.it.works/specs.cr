
describe DA_STYLE::Parser do
  it "works" do
    actual   = DA_STYLE::Parser.new("./input.css", __DIR__).to_css
    expected = File.read("#{__DIR__}/expected.css")

    should_eq actual, expected
  end # === it "works"
end # === desc "DA_STYLE::Parser"
