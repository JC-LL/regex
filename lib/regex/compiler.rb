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
        fsm_expr=expr.accept(self)
        current_state.to(fsm_expr.starter)
        current_state=fsm_expr.ender
      end
      ender=nfa.terminate # creates @ender
      current_state.to(ender)
      nfa
    end

    def visitAlt alt,args=nil
      nfa=NFA.new
      ender=nfa.terminate # creates @ender
      alt.exprs.each do |expr|
        fsm_expr=expr.accept(self)
        nfa.starter.to(fsm_expr.starter)
        fsm_expr.ender.to(ender)
      end
      nfa
    end


    def visitStar star,args=nil
      fsm=NFA.new
    end

    def visitPlus plus,args=nil
      fsm=NFA.new
    end

    def visitOpt opt,args=nil
      fsm=NFA.new
    end

    def visitRepeat repeat,args=nil
      fsm=NFA.new
    end

    def visitGroup group,args=nil
      fsm=NFA.new
    end

    def visitNonCapturingGroup nc_group,args=nil
      fsm=NFA.new
    end

    def visitAnyof any_of,args=nil
      fsm=NFA.new
    end

    def visitStartAnchor start_anchor,args=nil
      fsm=NFA.new
      fsm.ender=State.new(:ender)
      fsm.starter.to_on(fsm.ender,start_anchor.to_regex)
      fsm
    end

    def visitEndAnchor end_anchor,args=nil
      fsm=NFA.new
      fsm.ender=State.new(:ender)
      fsm.starter.to_on(fsm.ender,end_anchor.to_regex)
      fsm
    end
  end
end
