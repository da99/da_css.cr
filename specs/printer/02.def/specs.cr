
describe "DA_CSS::Printer def" do

  it "renders the block of css code" do
    should_eq actual!, expected!
  end # === it "works"

  it "uses a new scope" do
    input = %[
      RADIUS = 1px;
      def border-radius(RADIUS) { border-radius: {{RADIUS}}; }
      div {
        border-radius(2px);
        border-radius: {{RADIUS}};
      }
    ]
    expected = %[
      div {
        border-radius: 2px;
        border-radius: 1px;
      }
    ]
    should_eq SPEC_PARSER.new(input, __DIR__).to_css, expected
  end

end # === desc "DA_CSS::Printer"
