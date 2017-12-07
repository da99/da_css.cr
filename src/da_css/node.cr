
module DA_CSS

  alias NODES = Deque(Parser::NODE_TYPES)
  module Node

    def parent_node?
      !parent_node.is_a?(Nil)
    end # === def parent_node?

    def parent_node
      p = parent
      case p
      when Parser
        p.parent_node
      else
        nil
      end
    end # === def parent_node

    def self.from_chars(c : Chars)
      first = c.first
      last = c.last
      case
      when Color.looks_like?(c)
        Color.new(c)

      when Number_Unit.looks_like?(c)
        Number_Unit.new(c)

      when Percentage.looks_like?(c)
        Percentage.new(c)

      when Slash.looks_like?(c)
        Slash.new(c)

      else
        word = c.to_s
        {% begin %}
          case word
          when {{ system("cat \"#{__DIR__}/keywords.txt\"").split("\n").reject(&.empty?).map(&.stringify).join(", ").id }}
            Keyword.new(word)
          else
            Unknown.new(word)
          end
        {% end %}

      end
    end # === def self.from_chars

  end # === module Node

end # === module DA_CSS
