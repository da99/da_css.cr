
macro create_keyword(name)

  module Style

    struct {{name.id}}

      def initialize
      end # === def initialize

      def initialize(raw : String)
        if raw != "{{name.downcase.id}}"
          raise Exception.new("Invalid value for {{name.id}}: #{raw.inspect}")
        end
      end # === def initialize

      def value
        "{{name.downcase.id}}"
      end # === def value

    end # === struct {{name.id}}

  end # === module Style

end # === macro create_keyword

create_keyword "Top"
create_keyword "Bottom"
create_keyword "Left"
create_keyword "Right"
create_keyword "Center"
create_keyword "Initial"
create_keyword "Inherit"
create_keyword "Unset"
