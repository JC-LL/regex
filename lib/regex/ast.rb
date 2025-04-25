# Classes représentant les nœuds de l'AST
module Regex
  module AST
    class Literal
      attr_reader :char
      def initialize(char) = @char = char
      def to_regex = Regexp.escape(char)
    end

    class Alt
      attr_reader :exprs
      def initialize(*exprs) = @exprs = exprs
      def to_regex = exprs.map(&:to_regex).join("|")
    end

    class Seq
      attr_reader :exprs
      def initialize(*exprs) = @exprs = exprs
      def to_regex = exprs.map(&:to_regex).join
    end

    class Star
      attr_reader :expr
      def initialize(expr) = @expr = expr
      def to_regex = "#{expr.to_regex}*"
    end

    class Plus
      attr_reader :expr
      def initialize(expr) = @expr = expr
      def to_regex = "#{expr.to_regex}+"
    end

    class Opt
      attr_reader :expr
      def initialize(expr) = @expr = expr
      def to_regex = "#{expr.to_regex}?"
    end

    class Repeat
      attr_reader :min, :max, :expr
      def initialize(min, max, expr)
        @min = min
        @max = max
        @expr = expr
      end
      def to_regex
        max ? "#{expr.to_regex}{#{min},#{max}}" : "#{expr.to_regex}{#{min}}"
      end
    end

    class Group
      attr_reader :expr
      def initialize(expr) = @expr = expr
      def to_regex = "(#{expr.to_regex})"
    end

    class NonCapturingGroup
      attr_reader :expr
      def initialize(expr) = @expr = expr
      def to_regex = "(?:#{expr.to_regex})"
    end

    class AnyOf
     attr_reader :chars
     def initialize(*chars)
       @chars = chars.flatten
     end
     def to_regex
       # Ne pas échapper les "-" dans les ranges
       content = chars.map{|c| c.is_a?(AST::Range) ? "#{c.from.to_regex}-#{c.to.to_regex}" : c.to_regex}
       "[#{content.join}]"
     end
    end

    class Range
      attr_reader :from, :to
      def initialize(from, to)
        @from = from
        @to = to
        pp self
      end
      def to_regex
        "#{from.to_regex}-#{to.to_regex}"  # Sans échappement du -
      end
    end

    # Ancres
    class StartAnchor      # ^ (début de ligne)
      def to_regex = '^'
    end

    class AbsoluteStart    # \A (début absolu de chaîne)
      def to_regex = '\A'
    end

    # Ancres de fin
    class EndAnchor         # $
      def to_regex = '$'
    end

    class AbsoluteEnd       # \z
      def to_regex = '\z'
    end

    class WordBoundary      # \b (peut aussi être utilisé pour "début de mot")
      def to_regex = '\b'
    end

    # Classe de caractères exclus ([^...])
    class Not
      attr_reader :chars
      def initialize(*chars)
        @chars = chars.flatten
      end
      def to_regex = "[^#{chars.map(&:to_regex).join}]"
    end

    class Boundary
      def to_regex = '\b'
    end

    class PredefinedClass
      PREDEFINED = {
        digit: '\d',
        word:  '\w',
        space: '\s',
        any:   '.'
      }.freeze

      attr_reader :type
      def initialize(type) = @type = type
      def to_regex = PREDEFINED.fetch(type) { raise "Unknown class: #{type}" }
    end
  end #module AST
end #module Regex
