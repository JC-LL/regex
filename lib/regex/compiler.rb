module Regex
  class Compiler
    def compile re_sexp
      puts "compiling : #{re_sexp.to_s}"
      root=parse(re_sexp)
      puts "regexp : #{root.to_regex}"
      nfa=root.accept(self)
      nfa.print
      draw(nfa)
    end

    def parse str
      Regex::Parser.new.parse(str)
    end

    def draw nfa
      puts "drawing automata"
      Regex::DotDrawer.new.draw(nfa)
    end

    def visitLiteral lit,args=nil
      nfa=NFA.new
      ender=nfa.terminate # creates @ender
      nfa.starter.to(ender,lit.to_regex)
      nfa
    end

    def visitSeq seq,args=nil
      nfa=NFA.new
      current_state=nfa.starter
      seq.exprs.each do |expr|
        nfa_expr=expr.accept(self)
        current_state.to(nfa_expr.starter)
        current_state=nfa_expr.ender
      end
      ender=nfa.terminate # creates @ender
      current_state.to(ender)
      nfa
    end

    def visitAlt alt,args=nil
      nfa=NFA.new
      ender=nfa.terminate # creates @ender
      alt.exprs.each do |expr|
        nfa_expr=expr.accept(self)
        nfa.starter.to(nfa_expr.starter)
        nfa_expr.ender.to(ender)
      end
      nfa
    end

    def visitStar star,args=nil
      nfa=NFA.new
      starter=nfa.starter
      ender=nfa.terminate # creates @ender
      nfa_expr=star.expr.accept(self)
      starter.to(nfa_expr.starter)
      nfa_expr.ender.to(nfa_expr.starter)
      nfa_expr.ender.to(ender)
      starter.to(ender)
      nfa
    end

    def visitPlus plus,args=nil
      nfa=NFA.new
      starter=nfa.starter
      ender=nfa.terminate # creates @ender
      nfa_expr=star.expr.accept(self)
      starter.to(nfa_expr.starter)
      nfa_expr.ender.to(nfa_expr.starter)
      nfa_expr.ender.to(ender)
      nfa
    end

    def visitOpt opt,args=nil
      nfa=NFA.new
    end

    def visitRepeat repeat,args=nil
      nfa=NFA.new
    end

    def visitGroup group,args=nil
      nfa=NFA.new
    end

    def visitNonCapturingGroup nc_group,args=nil
      nfa=NFA.new
    end

    def visitAnyof any_of,args=nil
      nfa=NFA.new
    end

    def visitStartAnchor start_anchor,args=nil
      nfa=NFA.new
      nfa.ender=State.new(:ender)
      nfa.starter.to_on(nfa.ender,start_anchor.to_regex)
      nfa
    end

    def visitEndAnchor end_anchor,args=nil
      nfa=NFA.new
      nfa.ender=State.new(:ender)
      nfa.starter.to_on(nfa.ender,end_anchor.to_regex)
      nfa
    end
  end
end
