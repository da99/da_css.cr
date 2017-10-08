
style.cr
========

Instead of SASS or LESS, I am going to use
Crystal to generate CSS.

Note:
=======

This is not ready for production.

Example:
=======

```Crystal
class Page_Css

  include Style
  include Style::Keywords

  BLUE  = Hex_Color.new("#E3E0CF")
  GREY  = Hex_Color.new("#908E8E")
  PINK  = Hex_Color.new("#E85669")
  GREEN = Hex_Color.new("#4ab1a8")

  create_property "background-color"
  create_property "padding"
  create_property "width"
  create_property "float"

  macro col
    width percent(25)
    float left
  end

  def render

    # s_alias (means: selector alias)
    # s       (means: selector)

    s_alias("div") { |x|
      s(x) { background_color BLUE }
      s("#{x} span") { padding px(10) }
    }

    s("body") {
      background {
        color GREY
      }
    }

    s("#number") { col }
    s("#words") { col; background_color PINK }
    s("#quotation") { col; background_color GREEN }

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

