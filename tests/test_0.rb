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
Regex::AstDrawer.new.draw(ast)

puts "Regex: #{regex_s=ast.to_regex}"
str = "joe123@gmail.com"
answer=Regexp.new(regex_s).match?(str)
puts "#{regex_s} match? #{str} : #{answer}" # => true
