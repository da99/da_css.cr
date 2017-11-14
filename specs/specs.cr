
require "spec"
require "../src/da_css"

macro should_eq(a, e)
  strip_each_line({{a}}).should eq(strip_each_line({{e}}))
end # === macro should_eq

macro strip_each_line(s)
  {{s}}.split("\n").map { |s| s.strip }.reject { |s| s.empty? }.join("\n")
end # === macro strip_each_line

{% if !env("DA_CSS_PARSER") %}
  require "../src/da_css/dsl"
{% end %}
require "./parser/specs"


