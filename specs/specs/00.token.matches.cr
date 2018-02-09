
describe "Token#matches" do
  it "returns true if tokens have the same char" do
    a = DA_CSS::Token.new("abc")
    b = DA_CSS::Token.new("abc")
    assert a.matches?(b) == true
  end # === it "returns true if tokens have the same char"

  it "returns false if tokens have different sizes" do
    a = DA_CSS::Token.new("abc")
    b = DA_CSS::Token.new("abcc")
    assert a.matches?(b) == false
  end # === it "returns false if tokens have different sizes"

  it "returns false if tokens have same sizes, different chars" do
    a = DA_CSS::Token.new("abc")
    b = DA_CSS::Token.new("abd")
    assert a.matches?(b) == false
  end # === it "returns false if tokens have different sizes"

  it "returns true if one Token has been :strip!" do
    a = DA_CSS::Token.new(" abc ")
    a.strip!
    b = DA_CSS::Token.new("abc")
    assert a.matches?(b) == true
  end # === it "returns true if one Token has been :strip!"

end # === desc "Token#matches"
