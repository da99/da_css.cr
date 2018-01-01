
module DA_CSS

  class Token_Splitter

    @stack : Token = Token.new
    getter tokens = Tokens.new
    getter reader : Token_Reader
    delegate index, first?, last?, current, done?, to: @reader

    def initialize(t : Token)
      @reader = Token_Reader.new(t)
    end # === def initialize

    def initialize(@reader)
    end # === def initialize

    def <<(*args)
      push *args
    end

    def push(p : Position)
      @stack.push p
      self
    end # === def push

    def push(t : Token)
      @tokens.push t
      self
    end # === def push

    def token?
      !@stack.empty?
    end # === def empty?

    def split_with_index
      @reader.each_with_index { |p, i|
        yield p, i
      }
    end # === def split_with_index

    def consume_token
      raise Programmer_Error.new("Token can't be used since it is broken.") if @stack.empty?
      t = @stack
      @stack = Token.new
      t
    end # === def consume_token

    def consume_through(*args)
      save if token?
      @reader.consume_through(*args)
    end

    def consume_upto(*args)
      save if token?
      @reader.consume_upto(*args)
    end

    def next
      @reader.next
    end # === def next

    def save
      if @stack.empty?
        raise Programmer_Error.new("Token can't be saved because it is empty.")
      end
      @tokens << @stack
      @stack = Token.new
      self
    end # === def save

  end # === class Token_Splitter

end # === module DA_CSS
