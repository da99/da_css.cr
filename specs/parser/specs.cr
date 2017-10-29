
require "../../src/da_style/parser"

{% for x in `find #{__DIR__} -mindepth 1 -maxdepth 1 -type d `.split("\n").reject { |x| x.empty? } %}
  require ".{{x.gsub(/#{__DIR__}/, "").id}}/*"
{% end %}
