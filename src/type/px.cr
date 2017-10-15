
module DA_STYLE

  module PX

    def px(v)
      DA_STYLE::PX::VALUE.new(v)
    end # === def px

    struct VALUE

      def initialize(@i : Int32)
      end # === def initialize

      def write_to(io)
        io.raw! @i
        io.raw! "px" unless @i == 0
      end # === def write_to

    end # === struct PX

  end # === module PX

end # === module DA_STYLE
