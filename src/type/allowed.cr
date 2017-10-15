
module DA_STYLE

  struct Allowed

    @val : String
    def initialize(x)
      @val = x.to_s
    end # === def initialize

    def write_to(io)
      io.raw! @val
    end

  end # === struct Allowed

end # === module DA_STYLE
