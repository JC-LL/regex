require_relative '../lib/regex'

sxp = <<~SXP
  (alt 'a' 'b' 'c')  
SXP

compiler=Regex::Compiler.new
compiler.compile sxp
