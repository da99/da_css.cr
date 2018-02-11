
describe "it fails sample errors" do

  {{ system("find #{__DIR__}/../sample-errors -maxdepth 1 -type f -name *.css").stringify }}.strip.split("\n").reject(&.empty?).sort.each { |file|
    name = File.basename(file, ".css")
    File.read("#{file}").strip.split("\n").each { |l|
      next if l.strip.empty?
      it "fails property value: #{l}" do
        input = %[
        #{name} {
        #{l}
          }
        ]
        assert_raises(DA_CSS::CSS_Author_Error) {
          DA_CSS.parse(input)
        }
      end # === it "renders "
    }
  }

end # === desc "<|1|>"
