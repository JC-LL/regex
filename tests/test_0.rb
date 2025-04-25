require_relative '../lib/regex'

input = <<~SXP
  (seq
    (start)
    (plus (any-of "a-z" "0-9"))
    "@"
    (plus (any-of "a-z" "0-9"))
    "."
    (plus (any-of "a-z"))
    (end)
  )
SXP

parser = Regex::Parser.new
ast = parser.parse(input)
puts "="*80
puts "AST: #{ast.inspect}"
puts "="*80
puts "Regex: #{ast.to_regex}"
# => Regex: ^[a-z0-9]+@[a-z0-9]+\.[a-z]+$

parser  = Regex::Parser.new
regex_s = parser.parse(input).to_regex
puts "Regex: #{regex_s}"
test_email = "joe123@gmail.com"
p Regexp.new(regex_s).match?(test_email)  # => true

Regex::AstDrawer.new.draw(ast)
