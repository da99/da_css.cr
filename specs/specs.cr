
require "spec"
require "../src/da_css"

macro should_eq(a, e)
  strip_each_line({{a}}).should eq(strip_each_line({{e}}))
end # === macro should_eq

macro strip_each_line(s)
  {{s}}.split("\n").map { |s| s.strip }.reject { |s| s.empty? }.join("\n")
end # === macro strip_each_line

require "../../src/da_css"

class SPEC_PARSER
  struct Validator
    include DA_CSS::Validator
    def allow(x)
      x
    end # === def allow
  end # === struct Validator

  def initialize(str : String, dir : String)
    @raw = str
    @dir = dir
  end # === def initialize

  def to_css
    DA_CSS::Printer.new(@raw, Validator.new).to_css
  end # === def to_css
end # === class SPEC_PARSER

macro expected!
  File.read("#{__DIR__}/expected.css")
end # === macro expected!

macro actual!
  SPEC_PARSER.new("#{__DIR__}/input.css", __DIR__).to_css
end # === macro actual!

{% for x in `find #{__DIR__}/printer -mindepth 1 -maxdepth 1 -type d `.split("\n").reject { |x| x.empty? } %}
  require ".{{x.gsub(/#{__DIR__}/, "").id}}/*"
{% end %}
require "../../examples/*"


