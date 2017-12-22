
require "inspect_bang"

module DA_CSS
  SPACE    = ' '
  NEW_LINE = '\n'

  module Validator
    abstract def allow(x)
  end # === module Validator
end # === module DA_CSS

module DA_CSS

  alias NODE_TYPES =
    Node::Text | Node::Media_Query |
    Node::Selector_With_Body | Node::Comment |
    Node::Property | Node::Function_Call | Node::Color |
    Node::Keyword | Node::Property | Node::Number | Node::Number_Unit |
    Node::Percentage | Node::Slash | Node::Unknown


  def self.to_css(str : String, validator : DA_CSS::Validator)
    Printer.new(str, validator).to_css
  end # === def to_css

end # === module DA_CSS

require "./da_css/char/*"
require "./da_css/line"
require "./da_css/exception"

require "./da_css/raw/*"

require "./da_css/node/media_query_comma"
require "./da_css/node/media_query_keyword"
require "./da_css/node/media_query_condition"
require "./da_css/node/media_query_conditions"
require "./da_css/node/media_query"
require "./da_css/node/text"
require "./da_css/node/slash"
require "./da_css/node/unknown"
require "./da_css/node/color"
require "./da_css/node/comment"
require "./da_css/node/keyword"

require "./da_css/node/node"

require "./da_css/node/function_call"

require "./da_css/node/unit"
require "./da_css/node/number"
require "./da_css/node/number_unit"

require "./da_css/node/percentage"
require "./da_css/node/property"

require "./da_css/node/selector"
require "./da_css/node/selector_with_body"

require "./da_css/io_css"
require "./da_css/origin"
require "./da_css/parser"
require "./da_css/printer"


