
describe "A_Number" do

  it "returns an Int32 for :to_number when a whole negative number" do
    t = DA_CSS::Token.new("-1")
    n = DA_CSS::A_Number.new(t)
    assert n.to_number.class == Int32
  end # === it "turns an Int32"

  it "returns an Int32 for :to_number when a whole positive number" do
    t = DA_CSS::Token.new("10")
    n = DA_CSS::A_Number.new(t)
    assert n.to_number.class == Int32
  end # === it "turns an Int32"

  it "returns a Float for :to_number when a decimal positive number" do
    t = DA_CSS::Token.new("1.0")
    n = DA_CSS::A_Number.new(t)
    assert n.to_number.class == Float64
  end # === it "returns a Float for :to_number when a decimal positive number"

  it "raises an error if number for :to_number is invalid" do
    t = DA_CSS::Token.new("-.a")
    assert_raises(DA_CSS::CSS_Author_Error) {
      n = DA_CSS::A_Number.new(t)
    }
  end # === it "raises an error if number is invalid"

end # === desc "A_Number"
