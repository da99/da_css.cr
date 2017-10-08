
module Style

  struct Border_Radius_Corner

    include Style::Property

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
      write(
        "border-#{y.to_css}-#{x.to_css}-radius",
        raw
      )
    end # === def radius

  end # === struct Border_Radius_Corner

  {% for y in ["top", "bottom"] %}
    {% for x in ["left", "right"] %}
      macro border_{{y.id}}_{{x.id}}_radius(*args)
        scoped(Border_Radius_Corner) {
          radius {{y.id}}, {{x.id}}, \{{ *args }}
        }
      end
    {% end %}
  {% end %}

end # === module Style
