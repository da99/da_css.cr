

describe "Parses: Media Query List (e.g. @media ...this... )" do

  File.read(__DIR__ + "/valid.txt").strip.split("\n").each { |line|
    actual = line.split("->").first
    expect = line.split("->").last?
    it "parses: #{actual.inspect}" do
        t = DA_CSS::Token.new(actual)
        mql = DA_CSS::Media_Query_List.new(t)
        expect = (expect || line).strip
        assert(mql.to_s == expect)
    end
  }

  File.read(__DIR__ + "/invalid.txt").strip.split("\n").each { |line|
    it "raises when parsing: #{line.inspect}" do
        t = DA_CSS::Token.new(line)
        assert_raises(DA_CSS::CSS_Author_Error) {
          DA_CSS::Media_Query_List.new(t)
        }
    end
  }

end # === desc "Parses: media query list"
