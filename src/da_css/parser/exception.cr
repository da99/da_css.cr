
module DA_CSS

  module Parser

    macro def_exception(name, prefix, &blok)
      class {{name.id}} < Exception

        def prefix_msg
          {{prefix}}
        end

        def message
          "#{prefix_msg} #{@message}"
        end

        {% if blok %}
          {{blok.body}}
        {% end %}
      end # === class Invalid_Selector
    end # === macro def_exception

    def_exception Invalid_Property_Name, "Invalid property name: "
    def_exception Invalid_Property_Value, "Invalid property value: "
    def_exception Invalid_Selector, "Invalid selector: "
    def_exception Invalid_URL, "Invalid url: "
    def_exception Unknown_CSS_Function, "Unknown css function: "
    def_exception Output_File_Size_Max_Reached, "CSS output too large: " do
      def self.max_file_size
        5_000
      end
    end

  end # === module Parser

end # === module DA_CSS
