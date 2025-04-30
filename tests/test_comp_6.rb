require_relative '../lib/regex'

sxp = <<~SXP
    (opt
      (seq 'a' 'b' 'c')
    )
SXP

compiler=Regex::Compiler.new
compiler.compile sxp
