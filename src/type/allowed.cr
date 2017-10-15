
module DA_STYLE

  struct Allowed

    @val : String
    def initialize(x)
      @val = x.to_s
    end # === def initialize

    def to_css
      @val
    end

  end # === struct Allowed

end # === module DA_STYLE
