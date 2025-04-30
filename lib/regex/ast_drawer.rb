require_relative "code"
module Regex
  class AstDrawer
    def draw ast,filename="tree"
      puts "drawing ast"
      @printed=[]
      begin
        code=Code.new
        code << "digraph {"
        code.indent=2
        code << "ordering=out;"
        code << "ranksep=.4;"
        code << "bgcolor=\"lightgrey\";"
        code << ""
        code << "node [shape=box, fixedsize=false, fontsize=12, fontname=\"Helvetica-bold\", fontcolor=\"blue\""
        code << "       width=.25, height=.25, color=\"black\", fillcolor=\"white\", style=\"filled, solid, bold\"];"
        code << "edge [arrowsize=.5, color=\"black\", style=\"bold\"]"
        code << process(ast)
        code.indent=0
        code << "}"
        basename=File.basename(filename,'.nwa')
        save_file="#{basename}_ast.dot"
        code.save_as save_file,verbose=false
      rescue Exception =>e
        puts e
        puts e.backtrace
        raise
      end
    end

    private
    def id node
      node.object_id
    end

    def process node
      code=Code.new
      source=id(node)
      label=node.class.to_s.split("::").last
      code << "#{source}[label=\"#{label}\"]"

      node.instance_variables.each do |vname|
        ivar=node.instance_variable_get(vname)
        if @printed.include?(ivar)
          ivar=ivar.clone
        else
          @printed << ivar
        end
        vname=vname.to_s[1..-1]
        case ivar
        when Array
          ivar.each_with_index{|e,idx|
            sink=id(e)
            label=e.class.to_s.split("::").last
            code << "#{sink}[label=\"#{label}\"]"
            label_edge="#{vname}\[#{idx}\]"
            code << "#{source} -> #{sink} [label=\"#{label_edge}\"]"
            code << process(e)

          }
        when Symbol,String
          sink="#{ivar.to_s}".object_id
          ivar=ivar.to_s.gsub(/\"/,"\\\"")
          code << "#{sink}[label=\"#{ivar}\",color=red]"
          code << "#{source} -> #{sink} [label=\"#{vname}\"]"
        else
          sink=id(ivar)
          label=ivar.class.to_s.split("::").last
          code << "#{sink}[label=\"#{label}\"]"
          code << "#{source} -> #{sink} [label=#{vname}]"
          code << process(ivar)
        end
      end
      code
    end

  end
end
