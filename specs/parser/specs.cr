
require "../../src/da_css/parser"

class SPEC_PARSER
  include DA_CSS::Parser

end # === class SPEC_PARSER
macro expected!
  File.read("#{__DIR__}/expected.css")
end # === macro expected!

macro actual!
  SPEC_PARSER.new("/input.css", __DIR__).to_css
end # === macro actual!

{% for x in `find #{__DIR__} -mindepth 1 -maxdepth 1 -type d `.split("\n").reject { |x| x.empty? } %}
  require ".{{x.gsub(/#{__DIR__}/, "").id}}/*"
{% end %}
