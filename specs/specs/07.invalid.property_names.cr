
describe "Parser invalid property names" do

  {% for x in %w[ * & ^ % * ( ) + ] %}
    it "does not allow: '{{x.id}}'" do
      input = %[
        body { abc{{x.id}}: 1px; }
      ]

      assert_raises(DA_CSS::CSS_Author_Error) {
        DA_CSS.parse(input)
      }
    end # === it "does not allow: behaviour"
  {% end %}

end # === desc "Parser invalid property names"
