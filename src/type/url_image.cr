
module DA_STYLE

  struct URL_Image

    @value : String

    def initialize(raw : String)
      unless raw.match(/^[\.\/a-zA-Z0-9\-\_]{4,100}\.[a-zA-Z\_]{3,10}$/)
        raise Exception.new("Invalid value for url image address: #{raw.inspect}")
      end

      @value = raw
    end # === def initialize

    def raw
      @value
    end # === def raw

    def write_to(io)
      io.raw! "url('", @value, "')"
    end # === def value

  end # === struct URL_Image

  def url(s : String)
    URL_Image.new(s)
  end

end # === module DA_STYLE
