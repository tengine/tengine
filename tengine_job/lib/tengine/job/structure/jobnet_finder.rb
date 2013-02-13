require 'tengine/job/structure'

module Tengine::Job::Structure::JobnetFinder

  def find_descendant_edge(edge_id)
    edge_id = String(edge_id)
    visitor = Tengine::Job::Vertex::AnyVisitor.new do |vertex|
      if vertex.respond_to?(:edges)
        vertex.edges.detect{|edge| edge.id.to_s == edge_id}
      else
        nil
      end
    end
    visitor.visit(self)
  end
  alias_method :edge, :find_descendant_edge

  def find_descendant(vertex_id)
    vertex_id = String(vertex_id)
    return nil if vertex_id == self.id.to_s
    vertex(vertex_id)
  end

  def vertex(vertex_id)
    vertex_id = String(vertex_id)
    return self if vertex_id == self.id.to_s
    visitor = Tengine::Job::Vertex::AnyVisitor.new{|v| vertex_id == v.id.to_s ? v : nil }
    visitor.visit(self)
  end

  def find_descendant_by_name_path(name_path)
    return nil if name_path == self.name_path
    vertex_by_name_path(name_path)
  end

  def vertex_by_name_path(name_path)
    Tengine::Job::NamePath.absolute?(name_path) ?
      root.vertex_by_absolute_name_path(name_path) :
      vertex_by_relative_name_path(name_path)
  end

  def vertex_by_absolute_name_path(name_path)
    return self if name_path.to_s == self.name_path
    visitor = Tengine::Job::Vertex::AnyVisitor.new do |vertex|
      if name_path == (vertex.respond_to?(:name_path) ? vertex.name_path : nil)
        vertex
      else
        nil
      end
    end
    visitor.visit(self)
  end

  def vertex_by_relative_name_path(name_path)
    head, tail = *name_path.split(Tengine::Job::NamePath::SEPARATOR, 2)
    child = child_by_name(head)
    tail ? child.vertex_by_relative_name_path(tail) : child
  end

end
