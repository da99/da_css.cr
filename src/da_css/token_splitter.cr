
module DA_CSS

  class Token_Splitter

    @token : Token = Token.new
    getter tokens = Tokens.new
    getter reader : Token_Reader
    delegate current, done?, to: @reader


    def initialize(@reader)
    end # === def initialize

    def <<(*args)
      push *args
    end

    def push(p : Position)
      @token.push p
      self
    end # === def push

    def push(t : Token)
      @tokens.push t
      self
    end # === def push

    def token?
      !@token.empty?
    end # === def empty?

    def consume_token
      raise Programmer_Error.new("Token can't be used since it is broken.") if @token.empty?
      t = @token
      @token = Token.new
      t
    end # === def consume_token

    def consume_through(*args)
      save if token?
      new_token = @reader.consume_through(*args)
      @tokens << new_token
      self
    end

    def consume_upto(*args)
      save if token?
      new_token = @reader.consume_upto(*args)
      @tokens << new_token
      self
    end

    def next
      @reader.next
    end # === def next

    def save
      if @token.empty?
        raise Programmer_Error.new("Token can't be saved because it is empty.")
      end
      @tokens << @token
      @token = Token.new
      self
    end # === def save

  end # === class Token_Splitter

end # === module DA_CSS
