require_relative "code"

module Regex
  class DotDrawer
    def initialize
      @printed=[]
    end

    def draw nfa
      dot=Code.new
      dot << "digraph g {"
      dot.indent=2
      dot << "rankdir=\"LR\""
      dot << gen(nfa.starter)
      dot.indent=0
      dot << "}"
      dot.save_as "automata.dot"
    end

    def gen state
      dot=Code.new
      return if @printed.include?(self)
      state.transitions.each do |transition|
        cond,next_state=transition
        cond= (cond==:epsilon) ? "\u03b5": "'#{cond}'"
        dot << "#{state.id} -> #{next_state.id} [label=\"#{cond}\"]"
        @printed << state
        unless @printed.include?(next_state)
          dot << gen(next_state)
        end
      end
      dot
    end
  end
end
