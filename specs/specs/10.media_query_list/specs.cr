

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

end # === desc "Parses: media query list"
