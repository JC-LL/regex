require_relative '../lib/regex'

sxp = <<~SXP
    (seq
      (seq 'a' 'b' 'c')
      (seq 'd' 'e')
    )
SXP

compiler=Regex::Compiler.new
compiler.compile sxp
