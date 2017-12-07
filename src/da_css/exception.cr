
module DA_CSS

  class Error < Exception
    def message
      "Parser error: #{@message}"
    end # === def message
  end

  macro def_exception(name, prefix, &blok)
    class {{name.id}} < Error

      def prefix_msg
        {{prefix}}
      end

      def message
        "#{prefix_msg.strip} #{@message}"
      end

      {% if blok %}
        {{blok.body}}
      {% end %}
    end # === class Invalid_Selector
  end # === macro def_exception

  def_exception Invalid_Selector, "Invalid selector: "
  def_exception Invalid_URL, "Invalid url: "
  def_exception Unknown_CSS_Function, "Unknown css function: "
  def_exception Output_File_Size_Max_Reached, "CSS output too large: " do
    def self.max_file_size
      5_000
    end
  end

  class Invalid_Char < Exception

    def initialize(c : Char, prefix = "Invalid character: ")
      @message = "#{prefix}#{c}"
    end # === def initialize

    def initialize(i : Int32, prefix = "Invalid character: ")
      @message = "#{prefix}#{i.chr}"
    end # === def initialize

  end # === class Invalid_Char

  class Invalid_Unit < Exception

    def initialize(str : String)
      @message = "Invalid Unit: #{str.inspect}"
    end # === def initialize

    def initialize(cp : Chars)
      @message = "Invalid Unit: #{cp.to_s.inspect}"
    end # === def initialize

  end # === class Invalid_Unit

  class Invalid_Color < Exception

    def initialize(str : String)
      @message = "Invalid Color: #{str.inspect}"
    end # === def initialize

    def initialize(cp : Chars)
      @message = "Invalid Color: #{cp.to_s.inspect}"
    end # === def initialize

  end # === class Invalid_Color

end # === module DA_CSS

