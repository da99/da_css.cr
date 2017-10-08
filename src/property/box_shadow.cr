
module Style

  struct Box_Shadow

    include Style::Property

    def initialize(@io : IO::Memory)
    end # === def initialize

    def box_shadow(keyword : Inherit | Initial | Unset)
      write("box-shadow", keyword)
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

      write("box-shadow", *args)
    end

  end # === struct Box_Shadow

  macro box_shadow(*args)
    scoped(Box_Shadow) {
      box_shadow({{*args}})
    }
  end

end # === module Style
