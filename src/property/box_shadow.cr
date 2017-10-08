
module Style

  struct Box_Shadow

    create_keyword "Inherit"
    create_keyword "Initial"
    create_keyword "Unset"

    def initialize(@io : IO::Memory)
    end # === def initialize

    def box_shadow(keyword : Inherit | Initial | Unset)
      Style.write_property(@io, "box-shadow") { |x|
        x.<<(keyword)
      }
    end # === def box_shadow

    def box_shadow(*args)
      if args.empty?
        raise Exception.new("No values specified for box-shadow")
      end

      args.each { |x|
        case x
        when Length, Color, Int32
          x
        else
          raise Exception.new("Invalid value for box_shadow: #{x.inspect}")
        end
      }

      @io << " box-shadow: " << Style.join(*args) << ";"
    end

  end # === struct Box_Shadow

  macro box_shadow(*args)
    scoped(Box_Shadow) {
      box_shadow({{*args}})
    }
  end

end # === module Style
