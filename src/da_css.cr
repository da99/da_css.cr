
require "inspect_bang"

module DA_CSS
  SPACE    = ' '
  NEW_LINE = '\n'
  OPEN_PAREN = '('
  CLOSE_PAREN = ')'
end # === module DA_CSS

require "./da_css/exception"
require "./da_css/line"
require "./da_css/column"
require "./da_css/position"
require "./da_css/token"
require "./da_css/token_reader"
require "./da_css/token_splitter"

require "./da_css/raw/*"

require "./da_css/node_blok"
require "./da_css/node_media_query"
require "./da_css/media_query_condition"
require "./da_css/media_query_keyword"
require "./da_css/media_query_head"

require "./da_css/parser"
require "./da_css/validator"
require "./da_css/printer"

module DA_CSS

  alias RAW_NODE_TYPES =
    Raw_Media_Query |
    Raw_Blok

  alias NODE_TYPES =
    Node_Media_Query |
    Node_Blok

  def self.to_css(str : String)
    raw_nodes = Parser.parse(str)
    nodes = Validator.to_nodes(raw_nodes)
    Printer.to_css(nodes)
  end # === def to_css

end # === module DA_CSS



