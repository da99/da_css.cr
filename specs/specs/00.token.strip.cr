
describe "Token#strip!" do
  it "removes whitespace from end" do
    actual   = DA_CSS::Token.new("  a b c  ")
    actual.strip!
    expected = DA_CSS::Token.new("a b c")

    assert actual.to_s.inspect == expected.to_s.inspect
  end # === it "removes whitespace from end"

  it "removes whitespace from start" do
    actual   = DA_CSS::Token.new("  a b c")
    actual.strip!
    expected = DA_CSS::Token.new("a b c")
    assert actual.to_s.inspect == expected.to_s.inspect
  end # === it "removes whitespace from start"
end # === desc "Token#strip!"
