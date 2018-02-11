
describe "Token#includes?" do
  it "returns true when token has the targeted char" do
    t = DA_CSS::Token.new("abc")
    assert t.includes?('a') == true
    assert t.includes?('b') == true
    assert t.includes?('c') == true
  end # === it "returns true when token has the targeted char"

  it "returns false when token does not include targeted char" do
    t = DA_CSS::Token.new("123")
    assert t.includes?('a') == false
    assert t.includes?('b') == false
    assert t.includes?('c') == false
  end # === it "returns false when token does not include targeted char"
end # === desc "Token#includes?"
