
require "da_spec"
require "../src/da_css"

macro should_eq(a, e)
  %actual = strip_each_line({{a}})
  %expected = strip_each_line({{e}})
  if %actual != %expected
    STDERR.puts "==============================="
    STDERR.puts %actual
    STDERR.puts "==============================="
    STDERR.puts %expected
    STDERR.puts "==============================="
  end
  assert %actual == %expected
end # === macro should_eq

macro strip_each_line(s)
  {{s}}.split("\n").map { |s| s.strip }.reject { |s| s.empty? }.join("\n")
end # === macro strip_each_line

require "../../src/da_css"

module SPEC_PARSER

  def self.to_css(str)
    raw = File.exists?(str) ? File.read(str) : str
    DA_CSS.to_css(raw)
  end # === def to_css

end # === module SPEC_PARSER

macro expected!
  File.read("#{__DIR__}/expected.css").strip.split("\n").map(&.strip).join("\n")
end # === macro expected!

macro actual!
  SPEC_PARSER.to_css("#{__DIR__}/input.css").strip
end # === macro actual!

if !ARGV.empty?
  Describe.pattern(ARGV.join(" "))
end

macro expect_raises(klass, &blok)
  %err = nil
  begin
    {{blok.body}}
  rescue e : {{klass}}
    %err = e
  end

  assert %err.class == {{klass}}
end # === macro expect_raises

extend DA_SPEC

module DA_SPEC

  def examine(*args)
    args.each { |pair|
      key = pair.first
      val = pair.last
      if !val.is_a?(String)
        puts "================================================"
        puts "#{key}: (#{val.class})"
      end
      puts "================================================"
      puts val
    }
    puts "================================================"
  end # === def examine

end # === module DA_SPEC

# {% for x in `find #{__DIR__}/specs -mindepth 1 -maxdepth 1 -type d `.split("\n").reject { |x| x.empty? } %}
#   require ".{{x.gsub(/#{__DIR__}/, "").id}}/*"
# {% end %}
require "./specs/01.it.works/specs"
require "./specs/10.media_query_list/specs"
require "../../examples/*"


