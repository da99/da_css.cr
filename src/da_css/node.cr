
module DA_CSS

  module Node

    extend self

    def from_codepoints(c : Codepoints)
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
    end # === def self.from_codepoints

  end # === module Node

end # === module DA_CSS
