
module Style

  struct Border_Radius_Corner

    create_keyword "Top"
    create_keyword "Bottom"
    create_keyword "Right"
    create_keyword "Left"
    create_keyword "Inherit"

    alias Y      = Top | Bottom
    alias X      = Left | Right
    alias Length = Px | Em | Int32

    def initialize(@io : IO::Memory)
    end # === def initialize

    def radius(y : Y, x : X, raw : Length | Inherit)
      Style.write_property(@io, key(y, x)) { |prop|
        prop << raw
      }
    end # === def radius

    def key(y : Y, x : X)
      "border-#{y.to_css}-#{x.to_css}-radius"
    end # === def write_property

  end # === struct Border_Radius_Corner

  def border_radius_corner_scoped
    brc = Border_Radius_Corner.new(@io)
    with brc yield
  end # === def border_radius_corner_scoped

  {% for y in ["top", "bottom"] %}
    {% for x in ["left", "right"] %}
      macro border_{{y.id}}_{{x.id}}_radius(*args)
        border_radius_corner_scoped {
          radius {{y.id}}, {{x.id}}, \{{ *args }}
        }
      end
    {% end %}
  {% end %}

end # === module Style
