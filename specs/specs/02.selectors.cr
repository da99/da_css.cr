
describe "Selectors" do

  it "accepts selectors with tag ids: #my_button" do
    string = %[ #my_button { color: #fff; } ]
    bloks = DA_CSS::Parser.parse(string)
    assert bloks.first.selectors.first.to_s == "#my_button"
  end # === it "accepts selectors with tag ids: #my_button"

  it "accepts selectors with class names: div.red" do
    string = %[ div.red { color: #fff; } ]
    bloks = DA_CSS::Parser.parse(string)
    assert bloks.first.selectors.first.to_s == "div.red"
  end

  it "accepts selectors with psuedo-class: a:hover" do
    string = %[ a:hover { color: #fff; } ]
    bloks = DA_CSS::Parser.parse(string)
    assert bloks.first.selectors.first.to_s == "a:hover"
  end

  it "raises an Exception when selector has uppercase chars: DIV" do
    string = %[ DIV { color: #fff; } ]
    assert_raises(DA_CSS::CSS_Author_Error) {
      DA_CSS::Parser.parse(string)
    }
  end # === it "raises an Exception when selector has uppercase chars: #My_button"

  it "accepts multiple selectors with a comma: a, b, c" do
    string = %[ a, b, c { color: #fff; } ]
    bloks = DA_CSS::Parser.parse(string)
    blok  = bloks.first
    assert blok.selectors.first.to_s == "a"
    assert blok.selectors[1].to_s    == "b"
    assert blok.selectors.last.to_s  == "c"
  end # === it "accepts multiple selectors with a comma: a, b, c"

end # === desc "Selectors"
