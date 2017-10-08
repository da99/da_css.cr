
macro create_keyword(name, val)

  struct {{name.id}}

    def initialize
    end # === def initialize

    def initialize(raw : String)
      if raw != {{val}}
        raise Exception.new("Invalid value for {{name.id}}: #{raw.inspect}")
      end
    end # === def initialize

    def to_css
      {{val}}
    end # === def value

  end # === struct {{name.id}}

  def {{name.downcase.id}}
    {{name.id}}.new
  end
end # === macro create_keyword

macro create_keyword(name)

  create_keyword({{name}}, {{ name.downcase.gsub(/_/, "-") }})

end # === macro create_keyword



