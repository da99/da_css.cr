
macro create_keyword(name)

  {% str_value = name.downcase.gsub(/_/, "-").id %}

  struct {{name.id}}

    def initialize
    end # === def initialize

    def initialize(raw : String)
      if raw != "{{str_value}}"
        raise Exception.new("Invalid value for {{name.id}}: #{raw.inspect}")
      end
    end # === def initialize

    def to_css
      "{{str_value}}"
    end # === def value

  end # === struct {{name.id}}

  def {{name.downcase.id}}
    {{name.id}}.new
  end

end # === macro create_keyword



