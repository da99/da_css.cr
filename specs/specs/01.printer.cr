
describe DA_CSS::Printer do

  it "prints css" do
    input = %[
      div { background-color: #fff; }

      .empty {
        background-color: #000;
        font-size: 2em;
      }

      body {
        padding: 20px 0 0 10em;
        background-color: #000;
        background-repeat: no-repeat;
        background-color: #f0f;
        background-image: url("/sample/image-01.png");
      }
    ]

    expected = %[
      div {
        background-color: #fff;
      }
      .empty {
        background-color: #000;
        font-size: 2em;
      }
      body {
        padding: 20px 0 0 10em;
        background-color: #000;
        background-repeat: no-repeat;
        background-color: #f0f;
        background-image: url('/sample/image-01.png');
      }
    ]
    assert SPEC_PARSER.to_css(input) == strip(expected)
  end # === it "works"


end # === desc "DA_CSS::Printer"
