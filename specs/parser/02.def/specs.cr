
describe "DA_STYLE::Parser def" do

  it "works" do
    actual   = DA_STYLE::Parser.new("#{__DIR__}/input.css", __DIR__, :file).to_css
    expected = File.read(__DIR__ + "/expected.css")

    should_eq actual, expected
  end # === it "works"

end # === desc "DA_STYLE::Parser"
