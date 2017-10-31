# azimuth (obsolete)
# background (complexity)

PATTERN_COLOR = /^(currentcolor|transparent|inherit|initial|unset|[a-z]{3,15}|\#[a-z0-9A-Z]{3,8}|rgba?\([\ \,0-9\.\%]{2,25}\))$/
PATTERN_BORDER_STYLE = /^(none|hidden|dotted|dashed|solid|double|groove|ridge|inset|outset|inherit|initial|unset)$/
PATTERN_WIDTH = /^(thin|medium|think|inherit|initial|unset)|[0-9]{1,3}[a-z]{2,4}$/
PATTERN_BORDER = /^[0-9]{1,4}[a-z]{2,5}\ +(#{SEGMENT_BORDER_STYLE})\ +([a-z]{3,15}}|rgba?\(\ *[a-z0-9\,\ \%\.]{2,20}\ *\))$/
PATTERN_RADIUS = /^[0-9\ a-z\%\/]{2,25}$/

background-attachment /^(scroll|fixed|local|inherit|initial|unset)$/
background-clip       /^(border-box|padding-box|content-box|text|inherit|initial|unset)$/

background-color      PATTERN_COLOR

background-image      /^([,\ ]?url\('[\/a-zA-Z\.\_]+'\)[,\ ]?)+$/, /^(none|inherit|initial|unset)$/

background-position   /^([\d\%\ chempx\,topbottomleftright]+|top|bottom|left|right|center|inherit|initial|unset)$/

background-repeat     /^(repeat-x|repeat-y|repeat|space|round|no-repeat|inherit|initial|unset|\ ){1,50}$/

border                /^[0-9a-z\ ]{3,40}$/

border-bottom         PATTERN_BORDER

border-bottom-color   PATTERN_COLOR

border-bottom-style   PATTERN_BORDER_STYLE

border-bottom-width   PATTERN_WIDTH

border-collapse       /^(collapse|separate|inherit|initial|unset)$/

border-color          PATTERN_COLOR

border-left           PATTERN_BORDER

border-left-color     PATTERN_COLOR

border-left-style     PATTERN_BORDER_STYLE

border-left-width     PATTERN_WIDTH

border-radius         PATTERN_RADIUS

border-right          PATTERN_BORDER

border-right-color    PATTERN_COLOR

border-right-style    PATTERN_BORDER_STYLE

border-right-width    PATTERN_WIDTH

border-spacing        /^([0-9a-z\ ]{3,50}|inherit|initial|unset)$/

border-style          PATTERN_BORDER_STYLE

border-top            PATTERN_BORDER

border-top-color      PATTERN_COLOR

border-top-style      PATTERN_BORDER_STYLE

border-top-width      PATTERN_WIDTH

border-width          PATTERN_WIDTH

bottom                /^([0-9a-z\ \.\%]{2,50})|auto|inherit|initial|unset)$/

caption-side          /^(top|bottom|left|right|top-outside|bottom-outside|inherit|initial|unset)$/

clear                 /^(none|left|right|both|inline-start|inline-end|inherit|initial|unset)$/

clip                  /^(auto|inherit|initial|unset|rect\([0-9a-z\ \,]{3,50}\))$/

color                 PATTERN_COLOR

cursor                /^(pointer|auto|inherit|initial|unset)$/

direction             /^(ltr|rtl|inherit|initial|unset)$/

display               /^(block|inline|run-in|flow|flow-root|table|flex|grid|ruby|subgrid|(block|inline|run-in)\ +(flow|flow-root|table|flex|grid|ruby|subgrid)|(block flow|inline table|flex run-in)|list-item(\ +(block|inline|flow|flow-root|block flow|block flow-root))?|flow list-item block)|table-(row|header|footer|column)-group|table-(row|cell|column|caption)|ruby-(base|text|base-container|text-container)|contents|none|inline-block|inline-table|inline-flex|inline-grid|inherit|initial|unset$/

empty-cells           /^(show|hide|inherit|initial|unset)$/

float                 /^(left|right|none|inline-(start|end)|inherit|initial|unset)$/

font                  /^[a-zA-Z\"\,\ \-]{2, 50}(\ *\/\ *[a-z0-9\ ]{1,30})?$/

font-family           /^("[a-zA-Z\"\ ]{3,25}"\ *\,\ *)?(serif|sans-serif|monospace|cursive|fantasy|system-ui|inherit|initial|unset)$/

font-size             /^(xx-small|x-small|small|medium|large|x-large|xx-large|smaller|larger|inherit|initial|unset)|[0-9]{1,3}%|[0-9]{1,4}(\.[0-9])?([a-z]{2,5})$/

font-style            /^(normal|italic|oblique|inherit|initial|unset)$/

font-variant

font-weight

height

left

letter-spacing

line-height

list-style

list-style-image

list-style-position

list-style-type

margin

margin-bottom

margin-left

margin-right

margin-top

max-height

max-width

min-height

min-width

-moz-border-radius

-ms-border-radius

orphans

outline

outline-color

outline-style

outline-width

overflow

padding

padding-bottom

padding-left

padding-right

padding-top

page-break-after

page-break-before

page-break-inside

pause

pause-after

pause-before

pitch

pitch-range

play-during

position

quotes

richness

right

speak

speak-header

speak-numeral

speak-punctuation

speech-rate

stress

table-layout

text-align

text-decoration

text-indent

text-transform

top

unicode-bidi

vertical-align

visibility

voice-family

volume

white-space

widows

width

word-spacing

z-index

