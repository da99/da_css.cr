
describe "Errors" do

  File.read("specs/sample-errors/errors.css")
    .split("\n")
    .map(&.strip)
    .reject(&.empty?)
    .each { |l|
    it "fails property value: #{l}" do
      input = %[ div { #{l} } ]
      assert_raises(DA_CSS::CSS_Author_Error) {
        DA_CSS.parse(input)
      }
    end # === it "renders "
  }

end # === desc "Errors"
