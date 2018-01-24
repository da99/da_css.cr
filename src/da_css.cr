
require "inspect_bang"

module DA_CSS
  LETTERS       = 'a'..'z'
  SPACE         = ' '
  NEW_LINE      = '\n'
  COMMA         = ','
  OPEN_PAREN    = '('
  CLOSE_PAREN   = ')'
  OPEN_BRACKET  = '{'
  CLOSE_BRACKET = '}'
  HASH          = '#'
  UPPER         = 'A'..'Z'
  LOWER         = 'a'..'z'
  NUMBERS       = '0'..'9'
  SLASH         = '/'
  COLON         = ':'
end # === module DA_CSS

require "./da_css/exception"
require "./da_css/line"
require "./da_css/column"
require "./da_css/position"
require "./da_css/a_string"
require "./da_css/token"
require "./da_css/token_reader"
# require "./da_css/token_splitter"

# require "./da_css/raw/*"

# require "./da_css/node_blok"
# require "./da_css/media_query_list"
# require "./da_css/media_query_keyword"
# require "./da_css/media_query_condition"
# require "./da_css/media_query_condition_key_value"
# require "./da_css/media_query_head"
# require "./da_css/node_media_query"

require "./da_css/a_string"
require "./da_css/keyword"
require "./da_css/color"
require "./da_css/a_number"
require "./da_css/a_positive_whole_number"
require "./da_css/unit"
require "./da_css/ratio"
require "./da_css/number_unit"
require "./da_css/percentage"
require "./da_css/function_call"
require "./da_css/function_call_url"
require "./da_css/function_call_rgb"
require "./da_css/function_call_rgba"
require "./da_css/function_call_hsla"

require "./da_css/property_value_splitter"
require "./da_css/function_arg_splitter"

require "./da_css/blok"
require "./da_css/selector"
require "./da_css/property"

require "./da_css/parser"
require "./da_css/printer"

module DA_CSS

  def self.to_css(str : String)
    Printer.to_css(
      Parser.parse(str)
    )
  end # === def to_css

end # === module DA_CSS



