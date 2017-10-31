# azimuth (obsolete)
# background (complexity)
# text-decoration (complexity)

module DA_STYLE

  module Parser

    {% system("mkdir -p tmp") %}
    {% system("rm -f tmp/da_style.def_property.tmp") %}
    {% system("touch tmp/da_style.def_property.tmp") %}

    macro def_property(raw_name, r)
      {% if r.is_a?(Path) %}
        {% str = r.resolve.source.stringify %}
        {% const_name = r %}
      {% else %}
        {% str = r.source.stringify %}
        {% const_name = "PROPERTY_#{raw_name.gsub(/-/, "_").upcase.id}".id %}
        {{const_name}} = {{r}}
      {% end %}

      {% if str.starts_with?("\"^") && str.ends_with?("$\"") %}
        {% meth_name = "clean_#{raw_name.gsub(/-/, "_").id}".id %}
        {% system("bash -c \"echo #{raw_name} #{meth_name} >> tmp/da_style.def_property.tmp\"") %}
      {% else %}
        {% raise("Regex not secure: must start with ^ and end with $: #{raw_name} -> #{str.id}") %}
      {% end %}

      def {{meth_name}}(raw : String)
        return raw if raw.match({{const_name}})
        false
      end # === def meth_name

    end # === macro def_property

    LENGTH_PERCENT_0     = /#{SEGMENT_PERCENTAGE}|#{SEGMENT_LENGTH}|0/
    SEGMENT_MARGIN       = /#{LENGTH_PERCENT_0}|auto}|inherit|initial|unset/
    SEGMENT_UNITLESS     = /-?[0-9]{1,2}(\.?[0-9]{1})?/
    SEGMENT_NUMBER       = SEGMENT_UNITLESS
    SEGMENT_LENGTH       = /-?[0-9]{1,2}(\.?[0-9]{1})?[a-z]{2,5}/
    SEGMENT_PERCENTAGE   = /[0-9]{1,3}%/
    SEGMENT_BORDER_STYLE = /none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset|inherit|initial|unset/
    SEGMENT_STYLE        = /auto|none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset/
    SEGMENT_URL          = /url\('[\/a-zA-Z0-9\_\-\.]{3,100}'\)/
    SEGMENT_COLOR        = /currentcolor|transparent|[a-z]{3,15}|\#[a-z0-9A-Z]{3,8}|rgba?\([\ \,0-9\.\%]{2,25}\)/

    PATTERN_COLOR        = /^#{SEGMENT_COLOR}|inherit|initial|unset$/
    PATTERN_BORDER_STYLE = /^(none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset|inherit|initial|unset)$/
    PATTERN_WIDTH        = /^(thin|medium|think|inherit|initial|unset)|[0-9]{1,3}[a-z]{2,4}$/
    PATTERN_BORDER       = /^[0-9]{1,4}[a-z]{2,5}\ +(#{SEGMENT_BORDER_STYLE})\ +([a-z]{3,15}}|rgba?\(\ *[a-z0-9\,\ \%\.]{2,20}\ *\))$/
    PATTERN_RADIUS       = /^(\ *#{LENGTH_PERCENT_0}\ *){1,4}(\ *\/(\ *#{LENGTH_PERCENT_0}\ *){1,4})?$/

    def_property "background-attachment", /^(scroll|fixed|local|inherit|initial|unset)$/
    def_property "background-clip",       /^(border-box|padding-box|content-box|text|inherit|initial|unset)$/

    def_property "background-color",      PATTERN_COLOR

    def_property "background-image",      /^(([,\ ]?url\('[\/a-zA-Z\.\_]+'\)[,\ ]?)+$)|none|inherit|initial|unset$/

    def_property "background-position",   /^([\d\%\ chempx\,topbottomleftright]+|top|bottom|left|right|center|inherit|initial|unset)$/

    def_property "background-repeat",     /^(repeat-x|repeat-y|repeat|space|round|no-repeat|inherit|initial|unset|\ ){1,50}$/

    def_property "border",                /^[0-9a-z\ ]{3,40}$/

    def_property "border-bottom",         PATTERN_BORDER

    def_property "border-bottom-color",   PATTERN_COLOR

    def_property "border-bottom-style",   PATTERN_BORDER_STYLE

    def_property "border-bottom-width",   PATTERN_WIDTH

    def_property "border-collapse",       /^(collapse|separate|inherit|initial|unset)$/

    def_property "border-color",          PATTERN_COLOR

    def_property "border-left",           PATTERN_BORDER

    def_property "border-left-color",     PATTERN_COLOR

    def_property "border-left-style",     PATTERN_BORDER_STYLE

    def_property "border-left-width",     PATTERN_WIDTH

    def_property "border-radius",         PATTERN_RADIUS
    def_property "-moz-border-radius",    PATTERN_RADIUS
    def_property "-ms-border-radius",     PATTERN_RADIUS
    def_property "-webkit-border-radius", PATTERN_RADIUS

    def_property "border-right",          PATTERN_BORDER

    def_property "border-right-color",    PATTERN_COLOR

    def_property "border-right-style",    PATTERN_BORDER_STYLE

    def_property "border-right-width",    PATTERN_WIDTH

    def_property "border-spacing",        /^([0-9a-z\ ]{3,50}|inherit|initial|unset)$/

    def_property "border-style",          PATTERN_BORDER_STYLE

    def_property "border-top",            PATTERN_BORDER

    def_property "border-top-color",      PATTERN_COLOR

    def_property "border-top-style",      PATTERN_BORDER_STYLE

    def_property "border-top-width",      PATTERN_WIDTH

    def_property "border-width",          PATTERN_WIDTH

    def_property "bottom",                /^([0-9a-z\ \.\%]{2,50})|auto|inherit|initial|unset$/

    def_property "caption-side",          /^(top|bottom|left|right|top-outside|bottom-outside|inherit|initial|unset)$/

    def_property "clear",                 /^none|left|right|both|inline-start|inline-end|inherit|initial|unset$/

    def_property "clip",                  /^(auto|inherit|initial|unset|rect\([0-9a-z\ \,]{3,50}\))$/

    def_property "color",                 PATTERN_COLOR

    def_property "cursor",                /^(pointer|auto|inherit|initial|unset)$/

    def_property "direction",             /^(ltr|rtl|inherit|initial|unset)$/

    def_property "display",               /^(block|inline|run-in|flow|flow-root|table|flex|grid|ruby|subgrid|(block|inline|run-in)\ +(flow|flow-root|table|flex|grid|ruby|subgrid)|(block flow|inline table|flex run-in)|list-item(\ +(block|inline|flow|flow-root|block flow|block flow-root))?|flow list-item block)|table-(row|header|footer|column)-group|table-(row|cell|column|caption)|ruby-(base|text|base-container|text-container)|contents|none|inline-block|inline-table|inline-flex|inline-grid|inherit|initial|unset$/

    def_property "empty-cells",           /^(show|hide|inherit|initial|unset)$/

    def_property "float",                 /^(left|right|none|inline-(start|end)|inherit|initial|unset)$/

    # def_propertys "font",                  /^[a-zA-Z\"\,\ \-]{2, 50}(\ *\/\ *[a-z0-9\ ]{1,30})?$/

    def_property "font-family",           /^("[a-zA-Z\"\ ]{3,25}"\ *\,\ *)?(serif|sans-serif|monospace|cursive|fantasy|system-ui|inherit|initial|unset)$/

    def_property "font-size",             /^(xx-small|x-small|small|medium|large|x-large|xx-large|smaller|larger|inherit|initial|unset)|[0-9]{1,3}%|[0-9]{1,4}(\.[0-9])?([a-z]{2,5})$/

    def_property "font-style",            /^(normal|italic|oblique|inherit|initial|unset)$/

    def_property "font-variant",          /^[a-z\-\ ]{3,60}$/

    def_property "font-weight",           /^(normal|bold|lighter|bolder|inherit|initial|unset|[1-9]00)$/

    def_property "height",                /^(auto|fill|max-content|min-content|available|fit-content|[0-9]{1,3}([a-z]{2,5}|%)(\ *(border-box|content-box))?)$/

    def_property "left",                  /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|(auto|inherit)$/

    def_property "letter-spacing",        /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|(normal|inherit|initial|unset)$/

    def_property "line-height",           /^normal|#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|#{SEGMENT_UNITLESS}|inherit|initial|unset$/

    def_property "list-style-image",      /^#{SEGMENT_URL}$/

    def_property "list-style-position",   /^inside|outside|inherit|initial|unset$/

    def_property "list-style-type",       /^disc|circle|square|decimal|georgian|cjk-ideographic|kannada|-|none|inherit|initial|unset$/

    def_property "margin",                /^(\ *(#{SEGMENT_MARGIN})\ *){1,4}$/

    def_property "margin-bottom",         /^#{SEGMENT_MARGIN}$/
    def_property "margin-left",           /^#{SEGMENT_MARGIN}$/
    def_property "margin-right",          /^#{SEGMENT_MARGIN}$/
    def_property "margin-top",            /^#{SEGMENT_MARGIN}$/

    def_property "max-height",            /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|none|max-content|min-content|fit-content|fill-available|inherit|initial|unset$/
    def_property "max-width",             /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|none|max-content|min-content|fit-content|fill-available|inherit|initial|unset$/

    def_property "min-height",            /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|auto|max-content|min-content|fit-content|fill-available|inherit|initial|unset$/
    def_property "min-width",             /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|auto|max-content|min-content|fit-content|fill-available|inherit|initial|unset$/

    def_property "orphans",               /^#{SEGMENT_NUMBER}|inherit|initial|unset$/

    def_property "outline-color",         /^#{SEGMENT_COLOR}|invert|initial|unset$/
    def_property "outline-style",         /^#{SEGMENT_STYLE}|invert|initial|unset$/
    def_property "outline-width",         /^thin|medium|think|#{SEGMENT_LENGTH}|inherit$/

    def_property "overflow",              /^visible|hidden|scroll|auto|inherit|initial|unset$/

    def_property "padding",               /^(\ *(#{LENGTH_PERCENT_0})\ *){1,4}|inherit|initial|unset$/
    def_property "padding-bottom",        /^#{LENGTH_PERCENT_0}|inherit|initial|unset$/
    def_property "padding-left",          /^#{LENGTH_PERCENT_0}|inherit|initial|unset$/
    def_property "padding-right",         /^#{LENGTH_PERCENT_0}|inherit|initial|unset$/
    def_property "padding-top",           /^#{LENGTH_PERCENT_0}|inherit|initial|unset$/

    def_property "page-break-after",      /^auto|always|avoid|left|right|recto|verso|inherit|initial|unset$/
    def_property "page-break-before",     /^auto|always|avoid|left|right|recto|verso|inherit|initial|unset$/
    def_property "page-break-inside",     /^auto|avoid|inherit|initial|unet$/

    def_property "position",              /^static|relative|absolute|fixed|sticky|inherit|initial|unset$/

    def_property "right",                 /^#{LENGTH_PERCENT_0}|auto|inherit|initial|unset$/

    def_property "table-layout",          /^auto|fixed|inherit|initial|unset$/

    def_property "text-align",            /^left|right|center|justify|justify-all|start|end|match-parent|-moz-center|-webkit-center|inherit|initial|unset$/

    def_property "text-decoration-line",  /^none|inherit|initial|unset|[a-z\ \-]{2,20}$/
    def_property "text-decoration-color", /^#{SEGMENT_COLOR}$/
    def_property "text-decoration-style", /^solid|double|dotted|dashed|wavy|-moz-none|inherit|initial|unset$/

    def_property "text-indent",           /^#{LENGTH_PERCENT_0}(\* hanging\ *)?(\ *each_line\ *)?$/

    def_property "text-transform",        /^capitalize|uppercase|lowercase|none|full-width|inherit|initial|unset$/

    def_property "top",                   /^#{LENGTH_PERCENT_0}|auto|inherit|initial|unset$/

    def_property "unicode-bidi",          /^normal|embed|isolate|bidi-override|isolate-override|plaintext|inherit|initial|unset$/

    def_property "vertical-align",        /^#{LENGTH_PERCENT_0}|baseline|sub|super|text(-top|-bottom)|middle|bottom|inherit|initial|unset$/

    def_property "visibility",            /^visible|hidden|collapse|inherit|initial|unset$/

    def_property "white-space",           /^normal|nowrap|pre(-wrap|-line)?|inherit|initial|unset$/

    def_property "widows",                /^[1-9]|inherit|initial|unset$/

    def_property "width",                 /^((#{SEGMENT_PERCENTAGE}|#{SEGMENT_LENGTH})(\ {1,5}(border-box|content-box))?)|max-content|min-content|available|fit-content|auto|inherit|initial|unset$/

    def_property "word-spacing",          /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|0|normal|inherit|initial|unset$/

    def_property "z-index",               /^auto|-?[0-9]{1,3}$|inherit|initial|unset$/

    def clean_property!(raw_name : String, raw_value : String)
      value = clean_property(raw_name, raw_value)
      case value
      when String
        return value
      when :invalid_property_name
        raise Invalid_Property_Name.new("#{raw_name.inspect} (value: #{raw_value.inspect})")
      else
        raise Invalid_Property_Value.new("#{raw_name.inspect}: #{raw_value.inspect})")
      end
    end # === def clean_property!

    def clean_property(raw_name : String, raw_value : String)
      {% begin %}
        case raw_name
          {% for x in system("cat tmp/da_style.def_property.tmp").split("\n").reject { |x| x.strip.empty? } %}
            {% css_name = x.split.first.id %}
            {% meth_name = x.split.last.id %}
          when "{{css_name}}"
            result = {{meth_name}}(raw_value)
            return result
          {% end %}
          else
            :invalid_property_name
        end # === case
      {% end %}
    end # === def is_valid_property?

  end # === module Parser

end # === module DA_STYLE

