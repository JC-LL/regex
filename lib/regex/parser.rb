require 'sxp'
module Regex
  class Parser
    include Regex::AST

    def parse(input)
      sxp = SXP.read(input)
      build_ast(sxp)
    end

    private

    def build_ast(sexp)
      case sexp
      when String then Literal.new(sexp)
      when Symbol then build_symbol_based(sexp)
      when Array then build_list_based(sexp)
      else raise ArgumentError, "Invalid S-expression: #{sexp.inspect}"
      end
    end

    def build_symbol_based(sym)
      case sym.to_s.downcase
      when 'start' then StartAnchor.new  # ^
      when 'end'   then EndAnchor.new
      when 'word-boundary' then Boundary.new
      when 'digit', 'word', 'space', 'any' then PredefinedClass.new(sym.downcase.to_sym)
      else Literal.new(sym.to_s)
      end
    end

    def build_list_based(list)
      op, *args = list
      case op.to_s.downcase
      when 'start'     then StartAnchor.new      # ^
      when 'abs-start' then AbsoluteStart.new    # \A
      when 'end'       then EndAnchor.new        # $
      when 'abs-end'   then AbsoluteEnd.new      # \z
      when 'word-end'  then WordBoundary.new     # \b
      when 'alt'       then Alt.new(*args.map{|a| build_ast(a)})
      when 'seq'       then Seq.new(*args.map { |a| build_ast(a) })
      when 'star'      then Star.new(build_ast(args[0]))
      when 'plus'      then Plus.new(build_ast(args[0]))
      when 'opt'       then Opt.new(build_ast(args[0]))
      when 'repeat'
        min, max, expr = args.size == 3 ? args : [args[0], nil, args[1]]
        Repeat.new(min, max, build_ast(expr))
      when 'group'     then Group.new(build_ast(args[0]))
      when 'n-group'   then NonCapturingGroup.new(build_ast(args[0]))
        # Nouveaux opérateurs pour les classes de caractères
      when 'any-of','in', 'chars'
        items = list[1..].map do |item|
          if item.is_a?(String) && item.include?('-')
            from, to = item.split('-')
            Range.new(build_ast(from), build_ast(to))
          else
            build_ast(item)
          end
        end
        AnyOf.new(*items)
      when 'not'       then Not.new(args.map { |a| build_ast(a) })  # [^...]
      when 'range'     then Range.new(build_ast(args[0]), build_ast(args[1]))
      else
        raise ArgumentError, "Unknown operator: #{op.inspect}"
      end
    end
  end
end #module
