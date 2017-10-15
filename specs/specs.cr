
require "spec"
require "../src/da_style"
require "../src/type/url_image"

macro should_eq(a, e)
  strip_each_line({{a}}).should eq(strip_each_line({{e}}))
end # === macro should_eq

macro strip_each_line(s)
  {{s}}.split("\n").map { |s| s.strip }.reject { |s| s.empty? }.join("\n")
end # === macro strip_each_line

require "./specs/*"

# div {
#   background: #E3E0CF;
#   margin: 10px;
#   padding: 10px;
# }

# div span {
#  padding: 10px;
# }

# body {
#   background: #908E8E;
# }


# #number {
#   width: 25%;
#   float: left;
# }

# #words {
#   width: 25%;
#   float: left;
#   background: #E85669;
# }

# #quotation {
#   width: 25%;
#   float: left;
#   background: #4ab1a8;
# }

