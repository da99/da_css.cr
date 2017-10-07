
require "./border_radius"

module Style

  struct Border

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
      @io << " " << @key << "-width: " << w.to_css << ";"
      return self
    end # === def width

    def style(s : Style)
      @io << " " << @key << "-style: " << s.to_css << ";"
      return self
    end # === def style

    def color(c : Color)
      @io << " " << @key << "-color: " << c.to_css << ";"
      return self
    end # === def color

  end # === struct Border

  def border_scoped()
    border = Border.new(@content)
    with border yield
  end

  macro border(arg)
    border_scoped() {
      width {{arg.id}}
    }
  end

  macro border(arg1, arg2, arg3)
    border_scoped {
      width {{arg1.id}}
      style {{arg2.id}}
      color {{arg3.id}}
    }
  end

  {% for meth in ["width", "style", "color"] %}
    macro border_{{meth.id}}(*args)
      border_scoped {
        {{meth.id}}(\{{args.map { |x| x.id }.join(", ").id}})
      }
    end
  {% end %}

  {% for dir in ["top", "bottom", "left", "right"] %}
    macro border_{{dir.id}}(&blok)
      border_scoped {
        dir {{dir.id}}
        \{{blok.body}}
      }
    end

    macro border_{{dir.id}}(arg)
      border_scoped {
        dir {{dir.id}}
        width \{{arg.id}}
      }
    end # === macro border

    macro border_{{dir.id}}(arg1, arg2, arg3)
      border_scoped {
        dir {{dir.id}}
        width \{{arg1.id}}
        style \{{arg2.id}}
        color \{{arg3.id}}
      }
    end

    {% for meth in ["width", "style", "color"] %}
      macro border_{{dir.id}}_{{meth.id}}(*args)
        border_scoped {
          dir {{dir.id}}
          {{meth.id}}(\{{args.map { |x| x.id }.join(", ").id}})
        }
      end
    {% end %}
  {% end %}

end # === module Style
