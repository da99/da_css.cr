

module DA_CSS
  module KEYWORD

    macro create_keyword(name)
      create_keyword({{name}}, {{ name.downcase.gsub(/_/, "-") }})
    end # === macro create_keyword

    macro create_keyword(name, val)
      def {{name.downcase.id}}
        DA_CSS::KEYWORD::VALUE.new({{name}}, {{val}})
      end
    end # === macro create_keyword

    struct VALUE
      def initialize(@name : String, @value : String)
      end # === def initialize

      def write_to(io)
        io.raw! @value
      end # === def value
    end # === struct VALUE

    create_keyword "All"
    create_keyword "Auto"
    create_keyword "Border_Box"
    create_keyword "Bottom"
    create_keyword "Center"
    create_keyword "Contain"
    create_keyword "Content_Box"
    create_keyword "Cover"
    create_keyword "Currentcolor"
    create_keyword "Dashed"
    create_keyword "Dotted"
    create_keyword "Fixed"
    create_keyword "Inherit"
    create_keyword "Initial"
    create_keyword "Left"
    create_keyword "Local"
    create_keyword "Medium"
    create_keyword "None"
    create_keyword "No_Repeat"
    create_keyword "Repeat"
    create_keyword "Repeat_X"
    create_keyword "Repeat_Y"
    create_keyword "Right"
    create_keyword "Round"
    create_keyword "Scroll"
    create_keyword "Slash", '/'
    create_keyword "Solid"
    create_keyword "Space"
    create_keyword "Stretch"
    create_keyword "Text"
    create_keyword "Thick"
    create_keyword "Thin"
    create_keyword "Top"
    create_keyword "Transparent"
    create_keyword "Unset"

  end # === module KEYWORD
end # === module DA_CSS


