
module DA_CSS

  class Error < Exception

    def initialize(@message)
    end # === def message

    def initialize(@message, reader : Char_Deque)
      @message = "#{@message}: #{reader.pos_summary}"
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

    def message
      "Parser error: #{@message}"
    end # === def message

  end # === class Error

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

  class Invalid_Unit < Exception

    def initialize(str : String)
      @message = "Invalid Unit: #{str.inspect}"
    end # === def initialize

    def initialize(cp : Char_Deque)
      @message = "Invalid Unit: #{cp.to_s.inspect}"
    end # === def initialize

  end # === class Invalid_Unit

  class Invalid_Color < Exception

    def initialize(str : String)
      @message = "Invalid Color: #{str.inspect}"
    end # === def initialize

    def initialize(cp : Char_Deque)
      @message = "Invalid Color: #{cp.to_s.inspect}"
    end # === def initialize

  end # === class Invalid_Color

end # === module DA_CSS

