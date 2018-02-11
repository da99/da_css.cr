
module DA_CSS
  UPPER_CASE_LETTERS = 'A'..'Z'
  LOWER_CASE_LETTERS = 'a'..'z'
  NUMBERS            = '0'..'9'

  SPACE              = ' '
  NEW_LINE           = '\n'
  COMMA              = ','
  OPEN_PAREN         = '('
  CLOSE_PAREN        = ')'
  OPEN_BRACKET       = '{'
  CLOSE_BRACKET      = '}'
  HASH               = '#'
  SINGLE_QUOTE       = '\''
  DOUBLE_QUOTE       = '"'
  SLASH              = '/'
  COLON              = ':'

  alias FUNCTION_ARGS        = Deque(A_String | Percentage | A_Number | Number_Unit)
  alias PROPERTY_VALUE_TYPES = Comma | Slash | A_String | Percentage | A_Number | Number_Unit | Number_Units_Slashed | Color | Color_Keyword | Function_Call | Keyword
  alias PROPERTY_VALUE       = Deque(PROPERTY_VALUE_TYPES)

  def self.unsafe_ascii?(c : Char)
    c == '<' || c == '>' || c == '\n' || c.ord < 32 || c.ord > 126
  end

end # === module DA_CSS

require "./da_css/errors"

require "./da_css/Line"
require "./da_css/Column"
require "./da_css/Position"

require "./da_css/Token"
require "./da_css/Token_Reader"

require "./da_css/Keyword"
require "./da_css/Color"
require "./da_css/Color_Keyword"

require "./da_css/A_String"
require "./da_css/Slash"
require "./da_css/Comma"

require "./da_css/A_Number"
require "./da_css/Unit"
require "./da_css/Ratio"
require "./da_css/Number_Unit"
require "./da_css/Number_Units_Slashed"
require "./da_css/Percentage"

require "./da_css/Function_Call"
require "./da_css/Function_Arg_Splitter"

require "./da_css/Block"
require "./da_css/Selector"

require "./da_css/Property"
require "./da_css/Property_Value_Splitter"

require "./da_css/Parser"
require "./da_css/Printer"

module DA_CSS

  def self.parse(str : String)
    Parser.parse(str)
  end

  def self.to_css(x : Deque(Block))
    Printer.to_css( x ) 
  end

  def self.to_css(str : String)
    to_css( parse(str) )
  end # === def to_css

end # === module DA_CSS



