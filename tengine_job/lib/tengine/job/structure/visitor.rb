require 'tengine/job/structure'

module Tengine::Job::Structure::Visitor
  module Accepter
  def accept_visitor(visitor)
    visitor.visit(self)
  end
  end

  class Any
    def initialize(&block)
      @block = block
    end
    def visit(vertex)
      if result = @block.call(vertex)
        return result
      end
      vertex.children.each do |child|
        if result = child.accept_visitor(self)
          return result
        end
      end
      return nil
    end
  end

  class All
    def initialize(&block)
      @block = block
    end

    def visit(vertex)
      @block.call(vertex)
      vertex.children.each do |child|
        child.accept_visitor(self)
      end
    end
  end

  class AllWithEdge < All
    def visit(obj)
      if obj.respond_to?(:children)
        super(obj)
      else
        @block.call(obj)
      end
      return unless obj.respond_to?(:edges)
      obj.edges.each{|edge| edge.accept_visitor(self)}
    end
  end

end
