
describe "it runs samples" do

  `find specs/samples -maxdepth 1 -type f -name *.css`.strip.split("\n").reject(&.empty?).sort.each { |file|
    name = file.split("/").last.split(".").first
    it "renders: #{name}" do
      input = File.read("#{file}")
      actual = SPEC_PARSER.to_css(input)
      should_eq actual["#{name}: "], "#{name}: "
    end # === it "renders "
  }

end # === desc "<|1|>"
