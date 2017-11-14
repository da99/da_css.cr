# azimuth (obsolete)
# background (complexity)
# text-decoration (complexity)

module DA_CSS

    {% system("mkdir -p tmp") %}
    {% system("rm -f tmp/da_css.def_property.tmp") %}
    {% system("touch tmp/da_css.def_property.tmp") %}


    module Printer

      macro def_property(raw_name, r)
        # === A performance boost if we save the new regex into a CONSTANT
        #     and re-use it.
        {% const_name = "CSS_PROPERTY_#{raw_name.gsub(/-/, "_").upcase.id}_REGEX".id %}
        {{const_name}} = /^(#{{{r}}})$/

        {% meth_name = "clean_#{raw_name.gsub(/-/, "_").id}".id %}
        {% system("bash -c \"echo #{raw_name} #{meth_name} >> tmp/da_css.def_property.tmp\"") %}

        def {{meth_name}}(raw : String)
          return raw if raw.match({{const_name}})
          false
        end # === def meth_name

      end # === macro def_property

      CSS_GLOBAL_VALUES    = /inherit|initial|unset/
      SEGMENT_MARGIN       = /#{LENGTH_PERCENT_0}|auto|#{CSS_GLOBAL_VALUES}/
      SEGMENT_UNITLESS     = /-?[0-9]{1,2}(\.?[0-9]{1})?/
      SEGMENT_NUMBER       = SEGMENT_UNITLESS
      SEGMENT_LENGTH       = /(-?\.[0-9][a-z]{2,5})|(-?[0-9]{1,2}(\.?[0-9]{1})?[a-z]{2,5})/
      SEGMENT_PERCENTAGE   = /[0-9]{1,3}%/
      SEGMENT_STYLE        = /auto|none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset/
      SEGMENT_BORDER_STYLE = /#{SEGMENT_STYLE}|#{CSS_GLOBAL_VALUES}/
      SEGMENT_URL          = /url\('[\/a-zA-Z0-9\_\-\.]{3,100}'\)/
      SEGMENT_COLOR        = /currentColor|transparent|[a-z]{3,15}|\#[a-z0-9A-Z]{3,8}|rgba?\([\/\ \,0-9\.\%]{2,25}\)/
      SEGMENT_WIDTH        = /none|thin|medium|thick|0|(\d\.)?[0-9]{1,2}[a-z]{2,4}|[0-9]{1,3}[a-z]{2,4}/
      LENGTH_PERCENT_0     = /#{SEGMENT_PERCENTAGE}|#{SEGMENT_LENGTH}|0/

      PATTERN_COLOR        = /#{SEGMENT_COLOR}|#{CSS_GLOBAL_VALUES}/
      PATTERN_BORDER_STYLE = /(none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset|#{CSS_GLOBAL_VALUES})/
      PATTERN_WIDTH        = /#{SEGMENT_WIDTH}|#{CSS_GLOBAL_VALUES}/
      PATTERN_BORDER       = /#{SEGMENT_WIDTH}\ +(#{SEGMENT_BORDER_STYLE})\ +(#{SEGMENT_COLOR})/
      PATTERN_RADIUS       = /(\ *(#{LENGTH_PERCENT_0}|inherit)\ *){1,4}(\ *\/(\ *#{LENGTH_PERCENT_0}\ *){1,4})?/
      PATTERN_RADIUS_CORNER= /(\ *(#{LENGTH_PERCENT_0})\ *){1,2}/

      def_property "background-attachment", /^(scroll|fixed|local|#{CSS_GLOBAL_VALUES})/
      def_property "background-clip",       /^(border-box|padding-box|content-box|text|#{CSS_GLOBAL_VALUES})/

      def_property "background-color",      PATTERN_COLOR

      def_property "background-image",      /(\ *#{SEGMENT_URL}(\ *,\ *)?){1,10}|none|#{CSS_GLOBAL_VALUES}/

      def_property "background-position",   /([\d\%\ chempx\,centertopbottomleftright]{1,50})|#{CSS_GLOBAL_VALUES}/

      def_property "background-repeat",     /(repeat-x|repeat-y|repeat|space|round|no-repeat|#{CSS_GLOBAL_VALUES}|\ ){1,50}/

      def_property "border",                /[0-9a-z\ ]{3,40}/

      def_property "border-bottom",         PATTERN_BORDER

      def_property "border-bottom-color",   PATTERN_COLOR

      def_property "border-bottom-style",   PATTERN_BORDER_STYLE

      def_property "border-bottom-width",   PATTERN_WIDTH

      def_property "border-collapse",       /(collapse|separate|#{CSS_GLOBAL_VALUES})/

      def_property "border-color",          /(#{PATTERN_COLOR}\ *){1,4}/

      def_property "border-left",           PATTERN_BORDER

      def_property "border-left-color",     PATTERN_COLOR

      def_property "border-left-style",     PATTERN_BORDER_STYLE

      def_property "border-left-width",     PATTERN_WIDTH

      {% for x in ["", "-moz-", "-ms-", "-webkit-"] %}
        def_property "{{x.id}}border-radius", PATTERN_RADIUS
        def_property "{{x.id}}border-top-left-radius", PATTERN_RADIUS_CORNER
        def_property "{{x.id}}border-top-right-radius", PATTERN_RADIUS_CORNER
        def_property "{{x.id}}border-bottom-left-radius", PATTERN_RADIUS_CORNER
        def_property "{{x.id}}border-bottom-right-radius", PATTERN_RADIUS_CORNER
      {% end %}

      def_property "border-right",          PATTERN_BORDER

      def_property "border-right-color",    PATTERN_COLOR

      def_property "border-right-style",    PATTERN_BORDER_STYLE

      def_property "border-right-width",    PATTERN_WIDTH

      def_property "border-spacing",        /^([0-9a-z\ ]{3,50}|#{CSS_GLOBAL_VALUES})$/

      def_property "border-style",          /^((\ *#{SEGMENT_BORDER_STYLE}\ *){1,4})$/

      def_property "border-top",            PATTERN_BORDER

      def_property "border-top-color",      PATTERN_COLOR

      def_property "border-top-style",      PATTERN_BORDER_STYLE

      def_property "border-top-width",      PATTERN_WIDTH

      def_property "border-width",          /(#{PATTERN_WIDTH}\ *){1,4}/

      def_property "bottom",                /^([0-9a-z\ \.\%]{2,50})|auto|#{CSS_GLOBAL_VALUES}$/

      def_property "caption-side",          /^(top|bottom|left|right|top-outside|bottom-outside|#{CSS_GLOBAL_VALUES})$/

      def_property "clear",                 /^none|left|right|both|inline-start|inline-end|#{CSS_GLOBAL_VALUES}$/

      def_property "clip",                  /^(auto|#{CSS_GLOBAL_VALUES}|rect\([0-9a-z\ \,]{3,50}\))$/

      def_property "color",                 PATTERN_COLOR

      def_property "cursor",                /^(pointer|auto|#{CSS_GLOBAL_VALUES})$/

      def_property "direction",             /^(ltr|rtl|#{CSS_GLOBAL_VALUES})$/

      def_property "display",               /^(block|inline|run-in|flow|flow-root|table|flex|grid|ruby|subgrid|(block|inline|run-in)\ +(flow|flow-root|table|flex|grid|ruby|subgrid)|(block flow|inline table|flex run-in)|list-item(\ +(block|inline|flow|flow-root|block flow|block flow-root))?|flow list-item block)|table-(row|header|footer|column)-group|table-(row|cell|column|caption)|ruby-(base|text|base-container|text-container)|contents|none|inline-block|inline-table|inline-flex|inline-grid|#{CSS_GLOBAL_VALUES}$/

      def_property "empty-cells",           /^(show|hide|#{CSS_GLOBAL_VALUES})$/

      def_property "float",                 /^(left|right|none|inline-(start|end)|#{CSS_GLOBAL_VALUES})$/

      # def_propertys "font",                  /^[a-zA-Z\"\,\ \-]{2, 50}(\ *\/\ *[a-z0-9\ ]{1,30})?$/

      def_property "font-family",           /^("[\!\/\#\-\_\.a-zA-Z\ \d]{3,25}"\ *\,\ *)?(serif|sans-serif|monospace|cursive|fantasy|system-ui|#{CSS_GLOBAL_VALUES})$/

      def_property "font-size",             /^(xx-small|x-small|small|medium|large|x-large|xx-large|smaller|larger|#{CSS_GLOBAL_VALUES})|[0-9]{1,3}%|[0-9]{1,4}(\.[0-9])?([a-z]{2,5})$/

      def_property "font-style",            /^(normal|italic|oblique|#{CSS_GLOBAL_VALUES})$/

      def_property "font-variant",          /^[a-z\-\ ]{3,60}$/

      def_property "font-weight",           /^normal|bold|lighter|bolder|#{CSS_GLOBAL_VALUES}|[1-9]00$/

      def_property "height",                /^auto|fill|max-content|min-content|available|fit-content|[0-9]{1,3}([a-z]{2,5}|%)(\ *(border-box|content-box))?|#{CSS_GLOBAL_VALUES}$/

      def_property "left",                  /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|auto|#{CSS_GLOBAL_VALUES}$/

      def_property "letter-spacing",        /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|normal|#{CSS_GLOBAL_VALUES}$/

      def_property "line-height",           /^normal|#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|#{SEGMENT_UNITLESS}|#{CSS_GLOBAL_VALUES}$/

      def_property "list-style-image",      /^#{SEGMENT_URL}|none|#{CSS_GLOBAL_VALUES}$/

      def_property "list-style-position",   /^inside|outside|#{CSS_GLOBAL_VALUES}$/

      def_property "list-style-type",       /^'[\-\*\&\^\%\$\#\@\!\~\:\?\|]'|disc|circle|square|decimal|georgian|cjk-ideographic|kannada|-|none|#{CSS_GLOBAL_VALUES}$/

      def_property "margin",                /^(\ *(#{SEGMENT_MARGIN})\ *){1,4}$/

      def_property "margin-bottom",         /^#{SEGMENT_MARGIN}$/
      def_property "margin-left",           /^#{SEGMENT_MARGIN}$/
      def_property "margin-right",          /^#{SEGMENT_MARGIN}$/
      def_property "margin-top",            /^#{SEGMENT_MARGIN}$/

      def_property "max-height",            /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|none|max-content|min-content|fit-content|fill-available|#{CSS_GLOBAL_VALUES}$/
      def_property "max-width",             /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|none|max-content|min-content|fit-content|fill-available|#{CSS_GLOBAL_VALUES}$/

      def_property "min-height",            /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|auto|max-content|min-content|fit-content|fill-available|#{CSS_GLOBAL_VALUES}$/
      def_property "min-width",             /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|auto|max-content|min-content|fit-content|fill-available|#{CSS_GLOBAL_VALUES}$/

      def_property "orphans",               /^#{SEGMENT_NUMBER}|#{CSS_GLOBAL_VALUES}$/

      def_property "outline-color",         /^#{SEGMENT_COLOR}|invert|#{CSS_GLOBAL_VALUES}$/
      def_property "outline-style",         /^#{SEGMENT_STYLE}|invert|#{CSS_GLOBAL_VALUES}$/
      def_property "outline-width",         PATTERN_WIDTH

      def_property "overflow",              /^visible|hidden|scroll|auto|#{CSS_GLOBAL_VALUES}$/

      def_property "padding",               /^(\ *(#{LENGTH_PERCENT_0})\ *){1,4}|#{CSS_GLOBAL_VALUES}$/
      def_property "padding-bottom",        /^#{LENGTH_PERCENT_0}|#{CSS_GLOBAL_VALUES}$/
      def_property "padding-left",          /^#{LENGTH_PERCENT_0}|#{CSS_GLOBAL_VALUES}$/
      def_property "padding-right",         /^#{LENGTH_PERCENT_0}|#{CSS_GLOBAL_VALUES}$/
      def_property "padding-top",           /^#{LENGTH_PERCENT_0}|#{CSS_GLOBAL_VALUES}$/

      def_property "page-break-after",      /^auto|always|avoid|left|right|recto|verso|#{CSS_GLOBAL_VALUES}$/
      def_property "page-break-before",     /^auto|always|avoid|left|right|recto|verso|#{CSS_GLOBAL_VALUES}$/
      def_property "page-break-inside",     /^auto|avoid|#{CSS_GLOBAL_VALUES}$/

      def_property "position",              /^static|relative|absolute|fixed|sticky|#{CSS_GLOBAL_VALUES}$/

      def_property "right",                 /^#{LENGTH_PERCENT_0}|auto|#{CSS_GLOBAL_VALUES}$/

      def_property "table-layout",          /^auto|fixed|#{CSS_GLOBAL_VALUES}$/

      def_property "text-align",            /^left|right|center|justify|justify-all|start|end|match-parent|-moz-center|-webkit-center|#{CSS_GLOBAL_VALUES}$/

      def_property "text-decoration-line",  /^none|#{CSS_GLOBAL_VALUES}|[a-z\ \-]{2,20}$/
      def_property "text-decoration-color", /^#{SEGMENT_COLOR}$/
      def_property "text-decoration-style", /^solid|double|dotted|dashed|wavy|-moz-none|#{CSS_GLOBAL_VALUES}$/

      def_property "text-indent",           /^((#{LENGTH_PERCENT_0})(\ *hanging\ *)?(\ *each-line\ *)?)|#{CSS_GLOBAL_VALUES}$/

      def_property "text-transform",        /^capitalize|uppercase|lowercase|none|full-width|#{CSS_GLOBAL_VALUES}$/

      def_property "top",                   /^#{LENGTH_PERCENT_0}|auto|#{CSS_GLOBAL_VALUES}$/

      def_property "unicode-bidi",          /^normal|embed|isolate|bidi-override|isolate-override|plaintext|#{CSS_GLOBAL_VALUES}$/

      def_property "vertical-align",        /^#{LENGTH_PERCENT_0}|baseline|sub|super|text(-top|-bottom)|top|middle|bottom|#{CSS_GLOBAL_VALUES}$/

      def_property "visibility",            /^visible|hidden|collapse|#{CSS_GLOBAL_VALUES}$/

      def_property "white-space",           /^normal|nowrap|pre(-wrap|-line)?|#{CSS_GLOBAL_VALUES}$/

      def_property "widows",                /^[1-9]|#{CSS_GLOBAL_VALUES}$/

      def_property "width",                 /^((#{SEGMENT_PERCENTAGE}|#{SEGMENT_LENGTH})(\ {1,5}(border-box|content-box))?)|max-content|min-content|available|fit-content|auto|#{CSS_GLOBAL_VALUES}$/

      def_property "word-spacing",          /^#{SEGMENT_LENGTH}|#{SEGMENT_PERCENTAGE}|0|normal|#{CSS_GLOBAL_VALUES}$/

      def_property "z-index",               /^auto|-?[0-9]{1,3}$|#{CSS_GLOBAL_VALUES}$/

      def clean_property!(raw_name : String, raw_value : String)
        value = clean_property(raw_name, raw_value)
        case value
        when String
          return value
        when :invalid_property_name
          raise Invalid_Property_Name.new("#{raw_name.inspect} (value: #{raw_value.inspect})")
        else
          raise Invalid_Property_Value.new("#{raw_name.inspect}: #{raw_value.inspect}")
        end
      end # === def clean_property!

      def clean_property(raw_name : String, raw_value : String)
        {% begin %}
          case raw_name
            {% for x in system("cat tmp/da_css.def_property.tmp").split("\n").reject { |x| x.strip.empty? } %}
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

    end # === module Printer

end # === module DA_CSS


