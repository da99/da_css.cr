
class Example_01
  include DA_CSS::Printer

  def self.run
    new(%[
      body {
        color: #fff;
      }
    ], __DIR__).to_css
  end # === def self.to_css
end # === class Example_01

describe "Example 01: intro" do
  it "renders CSS" do
    should_eq Example_01.run, %[
      body {
        color: #fff;
      }
    ]
  end # === it "renders CSS"
end # === desc "Example 01: intro"
