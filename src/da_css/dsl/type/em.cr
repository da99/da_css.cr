
require "./positive_negative"
module DA_CSS

  module EM
    def em(i : Int32 | Float64)
      DA_CSS::EM::VALUE.new(i)
    end # === def em

    struct VALUE

      def initialize(@i : Int32 | Float64)
      end # === def initialize

      def write_to(io)
        io.raw! @i, "em"
      end # === def write_to

    end # === struct VALUE
  end # === module EM

end # === module DA_CSS
