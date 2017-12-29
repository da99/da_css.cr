
module DA_CSS

  struct Function_Call

    getter name : Token
    getter arg  : Token
    def initialize(@name, @arg)
    end # === def initialize

    def to_token
      t = Token.new
      name.each { |p|
        t.push p
      }
      arg.each { |p|
        t.push p
      }
      t
    end # === def to_token

  end # === struct Function_Call

end # === module DA_CSS
