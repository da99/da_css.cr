

describe "Parses: media query list (eg screen and (min-width: 30em) and (orientation: landscape))" do

  it "parses: screen and (min-width: 30em) and (orientation: landscape)" do
    txt = "screen and (min-width: 30em) and (orientation: landscape)"
    t = DA_CSS::Token.new(txt)
    mql = DA_CSS::Media_Query_List.new(t)
    actual = mql.to_s
    assert(actual == "screen and (min-width: 30em) and (orientation: landscape)")
  end # === it "parses: screen and (min-width: 30em) and (orientation: landscape)"

end # === desc "Parses: media query list"
