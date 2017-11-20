

input = %[

/*  comment
*?
*/
key0: 'some tstr';
a= b;
b = c    ;
c = d e e d    ;

a b c {
  key1: one two 1;
  key2 : one two 2;
  key3 :one two 3;/*
  comment
  two
  */
  key: one two 4;
  d {
    key4 '{ 'a' }' : one two 5;
    key5 "{ 'a' }" : one two 6;
  }
}

def{key4:one;}

]

require "./exception"
require "./codepoints"
require "./codepoints.array"
require "./node"
require "./node.unknown"
require "./node.empty_array"
require "./node.assignment"
require "./node.selector"
require "./node.comment"
require "./node.property"
require "./node.statement"
require "./doc"
require "./parser"
require "./io_css"
require "./printer"

macro inspect!(*args)
  begin
    puts(
      {{args}}.map { |x|
        x.inspect
      }.join(", ")
    )
  end
end

doc = Parser.new(input).parse


puts Printer.new(doc).to_css
