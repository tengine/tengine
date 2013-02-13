# -*- coding: utf-8 -*-
require 'tengine/job/template'

# Edgeとともにジョブネットを構成するグラフの「頂点」を表すモデル
# 自身がツリー構造を
class Tengine::Job::Template::Vertex
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Job::NamePath

  self.cyclic = true
  with_options(:class_name => self.name, :cyclic => true) do |c|
    c.embedded_in :parent  , :inverse_of => :children
    c.embeds_many :children, :inverse_of => :parent , :validate => false
  end

  before_validation do |r|
    r.children.each do |child|
      child.valid?
      child.errors.each do |f, error|
        r.errors.add(:base, error)
      end
    end
  end

#   def short_inspect
#     "#<%%%-30s id: %s>" % [self.class.name, self.id.to_s]
#   end
#   alias_method :long_inspect, :inspect
#   alias_method :inspect, :short_inspect

  class VertexValidations < Mongoid::Errors::Validations
    def translate(key, options)
      ::I18n.translate(
        "#{Mongoid::Errors::MongoidError::BASE_KEY}.validations",
        {:errors => Tengine::Job::Vertex.flatten_errors(document).to_a.join(', ')})
    end
  end


  class << self
    def flatten_errors(vertex, dest = nil)
      dest ||= []
      children_errors = vertex.errors.messages.delete(:children)
      edges_errors = vertex.errors.messages.delete(:edges)
      vertex.errors.full_messages.each{|msg| dest << "#{vertex.name_path} #{msg}"}
      vertex.children.each{|child| flatten_errors(child, dest)}
      if vertex.respond_to?(:edges)
        vertex.edges.each do|edge|
          edge.errors.full_messages.each{|msg| dest << "#{edge.name_for_message} #{msg}"}
        end
      end
      dest
    end

    def raise_flatten_errors
      yield if block_given?
    rescue Mongoid::Errors::Validations => e
      raise VertexValidations, e.document
    end

    def create!(*args, &block)
      raise_flatten_errors{ super(*args, &block) }
    end
  end

  def save!(*args)
    self.class.raise_flatten_errors{ super(*args) }
  end
  def update_attributes!(*args)
    self.class.raise_flatten_errors{ super(*args) }
  end



  def previous_edges
    return nil unless parent
    parent.edges.select{|edge| edge.destination_id == self.id}
  end
  alias_method :prev_edges, :previous_edges

  def next_edges
    return nil unless parent
    parent.edges.select{|edge| edge.origin_id == self.id}
  end

  def root
    (parent = self.parent) ? parent.root : self
  end

  def ancestors
    if parent = self.parent
      parent.ancestors + [parent]
    else
      []
    end
  end

  def ancestors_until_expansion
    if (parent = self.parent) && !self.was_expansion?
      parent.ancestors_until_expansion + [parent]
    else
      []
    end
  end

  IGNORED_FIELD_NAMES = ["_type", "_id"].freeze

  def actual_class; self.class; end
  def generating_attrs
    field_names = self.class.fields.keys - IGNORED_FIELD_NAMES
    field_names.inject({}){|d, name| d[name] = send(name); d }
  end
  def generating_children; self.children; end
  def generating_edges; respond_to?(:edges) ? self.edges : []; end

  def generate(klass = actual_class)
    result = klass.new(generating_attrs)
    src_to_generated = {}
    generating_children.each do |child|
      generated = child.generate
      src_to_generated[child.id] = generated.id
      result.children << generated
    end
    generating_edges.each do |edge|
      generated = edge.class.new
      generated.origin_id = src_to_generated[edge.origin_id]
      generated.destination_id = src_to_generated[edge.destination_id]
      result.edges << generated
    end
    result
  end

  def accept_visitor(visitor)
    visitor.visit(self)
  end

  class AnyVisitor
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

  class AllVisitor
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

  class AllVisitorWithEdge < AllVisitor
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
