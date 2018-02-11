
module DA_CSS

  class Error < Exception
  end # === class Error

  class Programmer_Error < Error
  end # === class Programmer_Error

  class CSS_Author_Error < Error

    def initialize(@message)
    end # === def message

    def initialize(@message, t : Token)
      @message = "#{@message}: #{t.summary}"
    end # === def message

    def initialize(*strs)
      first = true
      @message = strs.reduce(IO::Memory.new) { |io, x|
        io << " " unless first
        io << x.strip
        first = false
        io
      }.to_s
    end # === def message

  end # === class CSS_Author_Error

  macro def_exception(name, prefix, &blok)
    class {{name.id}} < CSS_Author_Error

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

  def_exception Unknown_CSS_Function, "Unknown css function: "
  def_exception Output_File_Size_Max_Reached, "CSS output too large: " do
    def self.max_file_size
      5_000
    end
  end

end # === module DA_CSS

