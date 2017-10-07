
module Style

  struct Background

    create_keyword "Top"
    create_keyword "Bottom"
    create_keyword "Left"
    create_keyword "Right"
    create_keyword "Center"
    create_keyword "Initial"
    create_keyword "Inherit"
    create_keyword "Unset"

    create_keyword "No_Repeat"
    create_keyword "Repeat_X"
    create_keyword "Repeat_Y"
    create_keyword "Repeat"
    create_keyword "Space"
    create_keyword "Round"

    create_keyword "Currentcolor"
    create_keyword "Transparent"
    create_keyword "Cover"
    create_keyword "Contain"
    create_keyword "Auto"

    create_keyword "Scroll"
    create_keyword "Fixed"
    create_keyword "Local"

    create_keyword "Border_Box"
    create_keyword "Padding_Box"
    create_keyword "Content_Box"
    create_keyword "Text"
    create_keyword "None"

    @io : IO::Memory

    def initialize(@io)
    end # === def initialize

    def url(raw : String)
      URL_Image.new(raw)
    end

    module Property_Methods

      def clip(keyword : Border_Box | Padding_Box | Content_Box | Text | Inherit | Initial)
        @io << " background-clip: " << keyword.to_css << ";"
        return self
      end

      def color(keyword : Currentcolor | Transparent | Inherit | Initial | Unset)
        @io << " background-color: " << keyword << ";"
        return self
      end # === def color

      def color(raw : String)
        color = Hex_Color.new(raw).to_css
        @io << " background-color: " << color << ";"

        return self
      end # === def color

      def color(color : Color)
        @io << " background-color: " << color.to_css << ";"

        return self
      end

      def image(keyword : None | Inherit | Initial | Unset)
        @io << " background-image: " << keyword.to_css << ";"
        return self
      end # === def image

      def image(url : URL_Image)
        @io << " background-image: " << url.to_css << ";"
        return self
      end

      def origin(keyword : Border_Box | Padding_Box | Content_Box | Inherit | Initial | Unset)
        @io << " background-origin: " << keyword.to_css << ";"
        return self
      end

      def position(raw : Top | Bottom | Left | Right | Center | Inherit | Initial | Unset)
        @io << " background-position: " << raw.to_css << ";"
        return self
      end

      def position(first : Em, second : Em)
        @io << " background-position: " << first.to_css << " " << second.to_css << ";"

        return self
      end # === def position

      def position(first : Percent, second : Percent)
        @io << " background-position: " << first.to_css << " " << second.to_css << ";"

        return self
      end # === def position

      def position(pos_1 : Top | Bottom, offset : Px | Em, pos_2 : Left | Right)
        @io << " background-position: "
        @io << pos_1.to_css << " "
        @io << offset.to_css << " "
        @io << pos_2.to_css
        @io << ";"

        return self
      end # === def position

      def position(pos_1 : Top | Bottom, pos_2 : Left | Right, offset : Px | Em)
        @io << " background-position: "
        @io << pos_1.to_css << " "
        @io << pos_2.to_css << " "
        @io << offset.to_css
        @io << ";"

        return self
      end # === def position

      def position(pos_1 : Top | Bottom, offset_1 : Px | Em, pos_2 : Left | Right, offset_2 : Px | Em)
        @io << " background-position: "
        @io << pos_1.to_css << " " << offset_1.to_css
        @io << " " << pos_2.to_css<< " " << offset_2.to_css
        @io << ";"
        return self
      end # === def position

      def repeat(keyword : Repeat_X | Repeat_Y | Repeat | Space | Round | No_Repeat | Inherit | Initial | Unset)
        @io << " background-repeat: " << keyword.to_css << ";"
        return self
      end

      def repeat(first : Repeat_X | Repeat | Space | Round | No_Repeat, second : Repeat_Y | Repeat | Space | Round | No_Repeat)
        @io << " background-repeat: " << first.to_css << " " << second.to_css ";"
        return self
      end

      def size(keyword : Cover | Contain | Auto | Inherit | Initial | Unset)
        @io << " background-size: " << keyword.to_css << ";"
        return self
      end

      def size(size : Percent | Em | Px)
        @io << " background-size: " << size.to_css << ";"
        return self
      end # === def size

      def size(first : Percent | Em | Px | Auto, second : Percent | Em | Px | Auto)
        @io << " background-size: " << first.to_css << " " << second.to_css << ";"
        return self
      end # === def size

      def attachment(keyword : Scroll | Fixed | Local | Inherit | Initial | Unset)
        @io << " background-attachment: " << keyword.to_css << ";"
        return self
      end # === def attachment

    end # === module Property_Methods

    include Property_Methods

  end # === struct Type_Background

  def background
    bg = Background.new(@content)
    with bg yield
  end # === def background

  {% for meth in Background::Property_Methods.methods %}
    macro background_{{meth.name}}(*args)
      background { {{meth.name}}(\{{ *args }}) }
    end
  {% end %}

end # === module Style
