
require "./border_radius"
require "./border_radius_corner"
require "./border_image"

module Style

  struct Border

    include Style::Property

    create_keyword "Dotted"
    create_keyword "Dashed"
    create_keyword "Solid"

    create_keyword "Medium"
    create_keyword "Thin"
    create_keyword "Thick"

    create_keyword "Top"
    create_keyword "Bottom"
    create_keyword "Left"
    create_keyword "Right"
    create_keyword "All"

    alias Width = Px | Em | Medium | Thin | Thick
    alias Style = Dashed | Dotted | Solid
    alias Dir = Top | Bottom | Left | Right

    def initialize(@io : IO::Memory)
      @key = "border"
    end # === def initialize

    def dir(dir : Dir | All)
      @key = case dir
             when All
               @key
             else
               "border-#{dir.to_css}"
             end
    end # === def dir

    def width(w : Width)
      write("border-width", w)
      return self
    end # === def width

    def style(s : Style)
      write("border-style", s)
      return self
    end # === def style

    def color(c : Color)
      write "border-color", c
      return self
    end # === def color

  end # === struct Border


  macro border(arg)
    scoped(Border) {
      width {{arg}}
    }
  end

  macro border(arg1, arg2, arg3)
    scoped(Border) {
      width {{arg1}}
      style {{arg2}}
      color {{arg3}}
    }
  end

  {% for meth in ["width", "style", "color"] %}
    macro border_{{meth.id}}(*args)
      scoped(Border) {
        {{meth.id}}(\{{*args}})
      }
    end
  {% end %}

  {% for dir in ["top", "bottom", "left", "right"] %}
    macro border_{{dir.id}}(&blok)
      scoped(Border) {
        dir {{dir.id}}
        \{{blok.body}}
      }
    end

    macro border_{{dir.id}}(arg)
      scoped(Border) {
        dir {{dir.id}}
        width \{{arg}}
      }
    end # === macro border

    macro border_{{dir.id}}(arg1, arg2, arg3)
      scoped(Border) {
        dir {{dir.id}}
        width \{{arg1.id}}
        style \{{arg2.id}}
        color \{{arg3.id}}
      }
    end

    {% for meth in ["width", "style", "color"] %}
      macro border_{{dir.id}}_{{meth.id}}(*args)
        scoped(Border) {
          dir {{dir.id}}
          {{meth.id}}( \{{*args}} )
        }
      end
    {% end %}
  {% end %}

end # === module Style
