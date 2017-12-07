
require "inspect_bang"

module DA_CSS
  macro file_read!(dir, raw)
    File.read(
      File.expand_path(
        File.join({{dir}}, {{raw}}.gsub(/\.+/, ".").gsub(/[^a-z0-9\/\_\-\.]+/, "_"))
      )
    )
  end # === macro file_read!

  module Validator
    abstract def allow(x)
  end # === module Validator

end # === module DA_CSS

require "./da_css/exception"
require "./da_css/chars"
require "./da_css/chars.group"
require "./da_css/node"
require "./da_css/node.unknown"
require "./da_css/node.empty_array"
require "./da_css/node.assignment"
require "./da_css/node.selector"
require "./da_css/node.selector_with_body"
require "./da_css/node.comment"
require "./da_css/node.color"
require "./da_css/node.slash"
require "./da_css/node.text"
require "./da_css/node.number"
require "./da_css/node.unit"
require "./da_css/node.function_call"
require "./da_css/node.number_unit"
require "./da_css/node.percentage"
require "./da_css/node.keyword"
require "./da_css/node.property"
require "./da_css/node.statement"
require "./da_css/io_css"
require "./da_css/parser"
require "./da_css/printer"

module DA_CSS

  def self.to_css(str : String, validator : DA_CSS::Validator)
    Printer.new(str, validator).to_css
  end # === def to_css

end # === module DA_CSS


