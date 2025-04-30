require_relative '../lib/regex'

input = <<~SXP
  (seq
    (start)
    'a'
    (end)
  )
SXP

parser = Regex::Parser.new
ast = parser.parse(input)
pp ast
Regex::AstDrawer.new.draw(ast)

puts "Regex: #{regex_s=ast.to_regex}"
str = "a"
answer=Regexp.new(regex_s).match?(str)
puts "#{regex_s} match? #{str} : #{answer}" # => true
