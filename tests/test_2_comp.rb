require_relative '../lib/regex'

sxp = <<~SXP
    (seq 'a' 'b' 'c')
SXP

compiler=Regex::Compiler.new
compiler.compile sxp
