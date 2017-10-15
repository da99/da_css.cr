
module DA_STYLE

  struct Zero

    def initialize
    end # === def initialize

    def initialize(z : Int32)
      if z != 0
        raise Exception.new("Only zero allowed.: #{z.inspect}")
      end
    end # === def initialize

    def write_to(io)
      io.raw! 0
    end # === def to_css

  end # === struct Zero

end # === module DA_STYLE
