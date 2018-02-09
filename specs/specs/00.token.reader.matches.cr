
describe "Token_reader#matches?" do
  it "returns true if token matches chars" do
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new("abc def"))
    assert r.matches?('a', 'b', 'c') == true
  end # === it "returns true if token matches chars"

  it "returns true if token matches chars at the middle" do
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new("abc def ghi"))
    4.times { r.next }
    assert r.matches?('d', 'e', 'f') == true
  end # === it "returns true if token matches chars"

  it "returns true if token matches chars at the end" do
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new("abc def"))
    4.times { r.next }
    assert r.matches?('d', 'e', 'f') == true
  end # === it "returns true if token matches chars"

  it "returns false if token does not matches chars" do
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new("abc def"))
    assert r.matches?('e', 'b', 'c') == false
  end # === it "returns false if token does not matches chars"

  it "returns false if token reader index is near the end" do
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new("abc def"))
    5.times { r.next }
    assert r.matches?('d', 'e', 'f') == false
  end # === it "returns false if token reader index is near the end"

  it "returns false if token reader index is on the last position" do
    string = "abc def"
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new(string))
    (string.size - 1).times { r.next }
    assert r.matches?('d', 'e', 'f') == false
  end # === it "returns false if token reader index is near the end"

  it "retusn false if chars are not found in token" do
    string = "abc def"
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new(string))
    assert r.matches?('d', 'e', 'g') == false
  end # === it "retusn false if chars are not found in token"

  it "returns false if char size longer than token size" do
    string = "abc"
    r = DA_CSS:: Token_Reader.new(DA_CSS::Token.new(string))
    assert r.matches?('d', 'e', 'g') == false
  end # === it "returns false if char size longer than token size"
end # === desc "Token#matches?"
