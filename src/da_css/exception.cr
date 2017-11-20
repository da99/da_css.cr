
module DA_CSS

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

  class Invalid_Char < Exception

    def initialize(i : Int32, prefix = "Invalid character: ")
      @message = "#{prefix}#{i.chr}"
    end # === def initialize

    def initialize(codepoints : Codepoints, str)
      @message = "#{str}: line #{self.class.line codepoints}"
    end # === def initialize

    def self.line(codepoints : Codepoints)
      index = codepoints.index
      new_line = '\n'.hash
      line = 1
      codepoints.origin.each_with_index { |x, i|
        if i == new_line
          line += 1
        end
        return line if i == index
      }
    end # === def line

  end # === class Invalid_Char

end # === module DA_CSS

