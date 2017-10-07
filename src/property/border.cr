
module Style

  struct Border

    create_keyword "Dotted"
    create_keyword "Dashed"
    create_keyword "Solid"

    create_keyword "Medium"
    create_keyword "Thin"
    create_keyword "Thick"

    alias Width = Px | Em | Medium | Thin | Thick
    alias Style = Dashed | Dotted | Solid

    def initialize(@io : IO::Memory)
    end # === def initialize

    def __(w : Width)
      @io << " border: " << w.value << ";"
      return self
    end # === def border

    def __(width : Width, style : Style, color : Color)
      @io << " border: " << width.value << " " << style.value << " " << color.value << ";"
      return self
    end # === def border

    module Property_Methods

      def width(w : Width)
        @io << " border-width: " << w.value << ";"
        return self
      end # === def width

      def style(s : Style)
        @io << " border-style: " << s.value << ";"
        return self
      end # === def style

      def color(c : Color)
        @io << " border-color: " << c.value << ";"
        return self
      end # === def color

    end # === module Property_Methods

    include Property_Methods
  end # === struct Border

  def border_scoped
    border = Border.new(@content)
    with border yield
  end

  macro border(*args)
    border_scoped {
      __({{args.map { |x| x.id }.join(", ").id}})
    }
  end # === macro border

  {% for meth in Border::Property_Methods.methods %}
    macro border_{{meth.name.id}}(*args)
      border_scoped {
        {{meth.name.id}}(\{{args.map { |x| x.id }.join(", ").id}})
      }
    end
  {% end %}

end # === module Style
