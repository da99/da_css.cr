
describe "Parser special characters" do

  it "allows strings with '{' " do
    input = %<
      form['{'] form ["{"] {
        border: 1px;
      }
    >

    actual = SPEC_PARSER.to_css(input)
    assert strip(actual) == strip(input)
  end # === it "allows strings with '{' "

  it "allows '[' or ']' in the selector" do
    input = %[
       #form2 input[value^='a'] {
         border: 1px;
       }
    ]

    actual = SPEC_PARSER.to_css(input)
    assert strip(actual) == strip(input)
  end # === it "does not allow [ or ] in the selector"

  it "allows '=' in the selector" do
    input = %[
       #form2 =a {
         border: 1px;
       }
    ]

    assert SPEC_PARSER.to_css(input) == strip(input)
  end # === it "does not allow [ or ] in the selector"

end # === desc "Parser special characters"
