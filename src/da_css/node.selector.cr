
module Node

  struct Selector

    getter head : Codepoints
    getter body : Doc

    def initialize(arr : Codepoints::Array, @body)
      @head = arr.join
    end # === def initialize

  end # === struct Selector

end # === module Node
