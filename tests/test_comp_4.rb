require_relative '../lib/regex'

sxp = <<~SXP
    (alt
      (seq 'a' 'b' 'c')
      (seq 'd' 'e' (alt 'f' 'g'))
    )
SXP

compiler=Regex::Compiler.new
compiler.compile sxp
