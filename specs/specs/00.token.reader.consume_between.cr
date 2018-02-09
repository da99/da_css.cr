
describe "Token_Reader#consume_between" do
  it "returns a token" do
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new("/* abc def */"))
    assert r.consume_between({'/', '*'}, {'*','/'}).class == DA_CSS::Token
  end # === it "returns a token"

  it "returns a token with the chars between the endpoints" do
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new("/* abc def */"))
    assert r.consume_between({'/', '*'}, {'*','/'}).strip!.to_s == "abc def"
  end # === it "returns a token with the chars between the endpoints"

  it "moves the reader to the char after the last endpoint" do
    starting = "/* abc */"
    ending = "def"
    string = starting + ending
    r = DA_CSS::Token_Reader.new(DA_CSS::Token.new(string))
    t = r.consume_between({'/', '*'}, {'*','/'})
    assert r.index == (starting.size)
  end # === it "moves the reader to the char after the last endpoint"
end # === desc "Token_Reader#consume_between"
