
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

require "./da_css/char/*"
require "./da_css/node/*"

require "./da_css/exception"
require "./da_css/line"
require "./da_css/io_css"
require "./da_css/origin"
require "./da_css/parser"
require "./da_css/printer"

module DA_CSS

  def self.to_css(str : String, validator : DA_CSS::Validator)
    Printer.new(str, validator).to_css
  end # === def to_css

end # === module DA_CSS


