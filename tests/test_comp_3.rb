require_relative '../lib/regex'

sxp = <<~SXP
    (alt
      (seq 'a' 'b' 'c')
      (seq 'd' 'e')
    )
SXP

compiler=Regex::Compiler.new
compiler.compile sxp
