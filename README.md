
style.cr
========

Instead of SASS or LESS, I am going to use
Crystal to generate CSS.

Example:
=======

This is not ready for production.

```Crystal
class Page_Css

  include Style
  BLUE = "#E3E0CF"
  GREY = "#908E8E"
  PINK = "#E85669"
  GREEN = "#4ab1a8"

  macro col
    width percent(25)
    float "left"
  end

  def render

    selector("div") { |x|
      __(x) { background BLUE }
      __("#{x} span") { padding px(10) }
    }

    __("body") {
      background GREY
    }

    __("#number") { col }
    __("#words") { col; background PINK }
    __("#quotation") { col; background GREEN }

    to_css
  end

end

puts Page_Css.render
```

The output:
```css
  div { background: #E3E0CF; }
  div span { padding: 10px; }
  body { background: #908E8E; }
  #number { width: 25%;  float: left;  }
  #words { width: 25%;  float: left;  background: #E85669; }
  #quotation { width: 25%;  float: left;  background: #4ab1a8; }
```

