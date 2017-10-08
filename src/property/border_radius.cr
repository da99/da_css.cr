
module Style

  struct Border_Radius

    create_keyword "Inherit"

    macro valid_slash!(var_name)
      if {{var_name}} != '/'
        raise Exception.new("Invalid value for slash: #{{{var_name}}.inspect}")
      end
    end

    def initialize(@io : IO::Memory)
      @key = "border-radius"
    end # === def initialize

    def radius(size : Length | Inherit)
      @io << " " << @key << ": " << size.to_css << ";"
      return self
    end # === def radius

    def radius(arg1 : Length, arg2 : Length)
      Style.write_property(@io, @key) { |x|
        x.<<(arg1, arg2)
      }
      return self
    end # === def radius

    def radius(arg1 : Length, arg2 : Length, arg3 : Length)

      Style.write_property(@io, @key) { |x|
        x.<<(arg1, arg2, arg3)
      }
      return self
    end # === def radius

    def radius(arg1 : Length, arg2 : Length, arg3 : Length, arg4 : Length)
      Style.write_property(@io, @key) { |x|
        x.<<(arg1, arg2, arg3, arg4)
      }
      return self
    end # === def radius

    def radius(arg1 : Length,
               arg2 : Length,
               slash : Char,
               arg3 : Length)
      valid_slash!(slash)
      Style.write_property(@io, @key) { |x|
        x.<<(
          arg1, arg2,
          slash,
          arg3
        )
      }

      return self
    end # === def radius

    def radius(arg1 : Length,
               arg2 : Length,
               slash : Char,
               arg3 : Length,
               arg4 : Length)
      valid_slash!(slash)
      Style.write_property(@io, @key) { |x|
        x.<<(
          arg1, arg2,
          slash,
          arg3, arg4
        )
      }
      return self
    end # === def radius

    def radius(arg1 : Length,
               arg2 : Length,
               arg3 : Length,
               slash : Char,
               arg4 : Length,
               arg5 : Length,
               arg6 : Length)
      valid_slash!(slash)
      Style.write_property(@io, @key) { |x|
        x.<<(
          arg1, arg2, arg3,
          slash,
          arg4, arg5, arg6,
        )

      }
      return self
    end # === def radius

    def radius(arg1 : Length,
               arg2 : Length,
               slash : Char,
               arg3 : Length,
               arg4 : Length,
               arg5 : Length,
               arg6 : Length)
      valid_slash!(slash)
      Style.write_property(@io, @key) { |x|
        x.<<(
          arg1, arg2,
          slash,
          arg3, arg4, arg5, arg6
        )
      }
      return self
    end # === def radius

  end # === struct Border_Radius

  macro border_radius(*args)
    scoped(Border_Radius) {
      radius( {{ *args }} )
    }
  end

end # === module Style

