
class Example_01

  struct Validator

    include DA_CSS::Validator

    def allow(x)
      x
    end # === def allow

  end # === struct Validator

  def self.to_css
    DA_CSS.to_css("body { color: #fff; }", Validator.new)
  end # === def self.to_css

end # === class Example_01

describe "Example 01: intro" do
  it "renders CSS" do
    should_eq Example_01.to_css, " body {\ncolor: #fff;\n} "
  end # === it "renders CSS"
end # === desc "Example 01: intro"
