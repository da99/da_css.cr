
require "../../src/da_style/parser"

macro expected!
  File.read(__DIR__ + "/expected.css")
end # === macro expected!

macro actual!
  DA_STYLE::Parser.new(__DIR__ + "/input.css", __DIR__, :file).to_css
end # === macro actual!

{% for x in `find #{__DIR__} -mindepth 1 -maxdepth 1 -type d `.split("\n").reject { |x| x.empty? } %}
  require ".{{x.gsub(/#{__DIR__}/, "").id}}/*"
{% end %}
