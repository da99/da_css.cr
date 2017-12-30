
module DA_CSS

  struct A_String

    @raw : Token
    def initialize(@raw)
      @raw.each { |x| self.class.valid!(x) }
    end # === def initialize

    def to_s
      @raw.each { |x| self.class.valid!(x) }
      "'#{@raw.to_s}'"
    end

    def print(printer : Printer)
      printer.raw! "'"
      @raw.print printer
      printer.raw! "'"
      self
    end # === def print

    def self.valid!(c : Char)
      case c
      when 'a'..'z', '0'..'9', '_', '-', '/', '.', '?'
        true
      else
        raise CSS_Author_Error.new("String can't contain this character: #{c.inspect}")
      end
    end # === def valid!

  end # === struct A_String

end # === module DA_CSS
