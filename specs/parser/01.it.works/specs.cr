
describe "DA_STYLE::Parser" do
  it "works" do
    css = %[

      GREY  = color(grey a(10%));
      WHITE = #FFF;
      BLACK = #000;
      LIGHT_BLACK = {{BLACK}}0011;

      div { background-color: {{WHITE}}; }
      .empty {
        background { color: {{BLACK}}; }
        font { size: 1em; }
        font-size: 2em;
      }
      @media (max-width: 12450px, min-width: 1000px) {
        body {
          padding: 20px 0 0 10em;
          background: {{BLACK}};
          background {
            color: {{GREY}};
            repeat: no-repeat;
          }
          background: {{LIGHT_BLACK}};
        }
      }

      include("./file.css");

    ]

    actual   = DA_STYLE::Parser.new(css, __DIR__).to_css
    expected = %[
    div {
      background-color: #FFF;
    }
    .empty {
      background-color: #000;
        font-size: 1em;
          font-size: 2em;
    }
    @media (max-width: 12450px, min-width: 1000px) {
        body {
          padding: 20px 0 0 10em;
          background: #000;
          background-color: color(grey a(10%));
          background-repeat: no-repeat;
          background: #0000011;
        }
    }
    .include {
      color: #0000011;
    }
    ]

    should_eq actual, expected
  end # === it "works"
end # === desc "DA_STYLE::Parser"
