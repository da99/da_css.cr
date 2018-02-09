
require "inspect_bang"
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

macro strip(x)
  %x = {{x}}
  if (%x).is_a?(String)
    %x.strip.split("\n").map(&.strip).join("\n")
  else
    %x
  end
end

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
    return previous_def if args.any? { |pair| !pair.last?.is_a?(String) }
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

require "../examples/*"
require "./specs/*"
# % for x in system(%[bash -c "cd \"#{__DIR__}\" && find ./specs -maxdepth 2 -mindepth 2 -type f -name specs.cr | sort --version-sort"]).strip.split("\n") %}
#   require {{x.gsub(/.cr$/, "")}}
# % end %}


