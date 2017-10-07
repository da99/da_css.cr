
module Style

  struct Background

    @io : IO::Memory

    def initialize(@io)
    end # === def initialize

    module Property_Methods

      def color(color : Color | String)
        case color
        when String
          color = Color.new(color)
        end
        @io << " background-color: " << color.value << ";"

        return self
      end

    end # === module Property_Methods

    include Property_Methods

  end # === struct Type_Background

  def background
    bg = Background.new(@content)
    with bg yield
  end # === def background

  {% for meth in Background::Property_Methods.methods %}
    def background_{{meth.name}}(*args)
      background { {{meth.name}}(*args) }
    end
  {% end %}

end # === module Style
