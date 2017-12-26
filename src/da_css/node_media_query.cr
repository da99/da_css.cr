
module DA_CSS

  struct Node_Media_Query

    getter raw : Raw_Media_Query
    def initialize(@raw)
    end # === def initialize

    def to_s(io)
      raw.to_s(io)
    end # === def print

  end # === struct Node_Media_Query

end # === module DA_CSS
