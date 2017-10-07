
require "./type/percent"
require "./type/px"
require "./type/em"
require "./type/color"
require "./type/int32"
require "./type/float64"

require "./property/background"
require "./property/width"
require "./property/float"
require "./property/padding"

module Style

  module Class_Methods
    def render
      style = self.new
      style.render
    end
  end

  macro included
    extend Style::Class_Methods
  end

  macro p(name, *args)
    {{name.gsub(/-/, "_").id}}({{args.map { |x| x.id }.join(", ").id}})
  end

  @in_nest = false

  def initialize
    @content = IO::Memory.new
  end # === def initialize

  def to_css
    @content.to_s
  end

  def render
    with self yield(self)
  end # === def render

  def s(name : String)
    @content << "\n" << name << " {"
    with self yield
    @content << " }"

    return self
  end

  def s_alias(name : String)
    raise Exception.new("Nesting of :rename not allowed.") if @in_nest
    @in_nest = true
    with self yield(name)
    @in_nest = false
    return self
  end

  def css
    @content.to_s
  end

end # === module Style
