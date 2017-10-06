

require "../src/style"

class Page_Css

  include Style
  BLUE = "#E3E0CF"
  GREY = "#908E8E"
  PINK = "#E85669"
  GREEN = "#4ab1a8"

  macro col
    width 25.percent
    float "left"
  end

  def render

    s_alias("div") { |x|
      s(x) { background BLUE }
      s("#{x} span") { padding 10.px }
    }

    s("body") {
      background GREY
    }

    s("#number") { col }
    s("#words") { col; background PINK }
    s("#quotation") { col; background GREEN }

    to_css
  end

end

css = Page_Css.render

puts css
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

