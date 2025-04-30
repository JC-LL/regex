module Regex
  class State
    @@id=-1
    attr_reader :id,:transitions
    def initialize
      @id="S#{@@id+=1}"
      @transitions=[]
    end

    def to(next_state,cond=:epsilon)
      @transitions << [cond,next_state]
    end

    def print
      @printed||=[]
      @transitions.each do |transition|
        cond,next_state=transition
        puts "#{self.id} -#{cond}-> #{next_state.id}"
        unless @printed.include?(next_state)
          next_state.print
        end
        @printed << self
      end
    end
  end

  class Automata
    attr_accessor :states,:starter,:ender
    def initialize
      @starter=State.new
      @states=[@starter]
    end

    def << state
      @states << state
    end

    def terminate
      @states << @ender=State.new()
      @ender #returns ender
    end

    def print
      self.starter.print
    end
  end

  class NFA < Automata
  end

  class DFA < Automata
  end
end
