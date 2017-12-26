
module DA_CSS

  class Validator

    def self.to_nodes(raw : Deque(RAW_NODE_TYPES))
      nodes = Deque(NODE_TYPES).new
      raw.each { |x|
        new_node = case x
                   when Raw_Blok
                     Node_Blok.new(x)
                   when Raw_Media_Query
                     Node_Media_Query.new(x)
                   else
                     raise Programmer_Error.new("Unknown type: #{x.class}")
                   end
        nodes.push(new_node)
      }
      nodes
    end # === def self.to_nodes

    getter raw : Deque(Token)
    getter nodes = Deque(NODE_TYPES).new

    def initialize(@raw)
    end # === def initialize

    def run
    end # === def run

  end # === class Validator

end # === module DA_CSS
