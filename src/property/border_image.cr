
module Style

  struct Border_Image

    create_keyword "Repeat"
    create_keyword "Stretch"
    create_keyword "Round"
    create_keyword "None"
    create_keyword "Inherit"
    create_keyword "Initial"
    create_keyword "Unset"

    def initialize(@io : IO::Memory)
    end # === def initialize

    def url(*args)
      URL_Image.new(*args)
    end # === def url

    def source(addr : None | URL_Image | Linear_Gradient | Inherit | Initial | Unset)
      Style.write_property(@io, key("source")) { |x|
        x.<<(addr)
      }
    end

    macro not_ready(name)
      def {{name.id}}(*args)
        raise Exception.new("not ready: border-image-{{name.id}}")
      end
    end

    not_ready "slice"
    not_ready "width"
    not_ready "repeat"
    not_ready "outset"

    def key(k)
      "border-image-#{k}"
    end # === def key

    macro body_image_specs
      border_image {
        source none
        slice 100.percent
        width 1
        width 1, 2.em, 30.percent
        width 1, 2.em, 30.percent, 50.percent
        outset 30.px, 2, 1.5
        repeat round, stretch
      }
    end

  end # === struct Border_Image

  macro border_image(&blok)
    scoped(Border_Image) {
      {{blok.body}}
    }
  end # === macro border_image

end # === module Style
