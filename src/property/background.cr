
module Style

  struct Background

    @io : IO::Memory

    def initialize(@io)
    end # === def initialize

    module Property_Methods

      def clip(val : String)
        case val
        when "border-box", "padding-box", "content-box", "text", "inherit", "initial"
          @io << " background-clip: " << val << ";"
        else
          raise Exception.new("Invalid value for background-clip: #{val.inspect}")
        end
      end

      def color(raw : String)
        downcase = raw.downcase
        color = case downcase
                when "currentcolor", "transparent", "inherit", "initial", "unset"
                  downcase
                else
                  Hex_Color.new(raw).value
                end

        @io << " background-color: " << color << ";"

        return self
      end # === def color

      def color(color : Color)
        @io << " background-color: " << color.value << ";"

        return self
      end

      def image(raw : String)
        case raw
        when "none", "inherit", "initial", "unset"
          @io << " background-image: " << raw << ";"
        else
          raise Exception.new("Invalid value for background-image: #{raw.inspect}")
        end
      end # === def image

      def url(raw : String)
        URL_Image.new(raw)
      end

      def image(url : URL_Image)
        @io << " background-image: " << url.value << ";"
      end

      def origin(raw : String)
        case raw
        when "border-box", "padding-box", "content-box", "inherit", "initial", "unset"
          @io << " background-origin: " << raw << ";"
        else
          raise Exception.new("Invalid value for background-origin: #{raw}")
        end
      end

      def position(raw : Top | Bottom | Left | Right | Center | Inherit | Initial | Unset)
        @io << " background-position: " << raw.value << ";"
      end

      def position(first : Em, second : Em)
        @io << " background-position: " << first.value << " " << second.value << ";"
      end # === def position

      def position(first : Percent, second : Percent)
        @io << " background-position: " << first.value << " " << second.value << ";"
      end # === def position

      def position(pos_1 : Top | Bottom, offset : Px | Em, pos_2 : Left | Right)
        @io << " background-position: "
        @io << pos_1.value << " "
        @io << offset.value << " "
        @io << pos_2.value
        @io << ";"
      end # === def position

      def position(pos_1 : Top | Bottom, pos_2 : Left | Right, offset : Px | Em)
        @io << " background-position: "
        @io << pos_1.value << " "
        @io << pos_2.value << " "
        @io << offset.value
        @io << ";"
      end # === def position

      def position(pos_1 : Top | Bottom, offset_1 : Px | Em, pos_2 : Left | Right, offset_2 : Px | Em)
        @io << " background-position: "
        @io << pos_1.value << " " << offset_1.value
        @io << " " << pos_2.value<< " " << offset_2.value
        @io << ";"
      end # === def position

      def repeat
        raise Exception.new("not ready")
      end

      def size
        raise Exception.new("not ready")
      end

      def attachment
        raise Exception.new("not ready")
      end

    end # === module Property_Methods

    include Property_Methods

  end # === struct Type_Background

  def background
    bg = Background.new(@content)
    with bg yield
  end # === def background

  {% for meth in Background::Property_Methods.methods %}
    macro background_{{meth.name}}(*args)
      background { {{meth.name}}(\{{args.map { |x| x.id }.join(", ").id}}) }
    end
  {% end %}

end # === module Style
