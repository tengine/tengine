# -*- coding: utf-8 -*-
require 'tengine/job/template'

# Edgeとともにジョブネットを構成するグラフの「頂点」を表すモデル
# 自身がツリー構造を
class Tengine::Job::Template::Vertex
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Job::Structure::NamePath
  include Tengine::Job::Structure::Tree
  include Tengine::Job::Structure::Visitor::Accepter

  self.cyclic = true
  with_options(:class_name => self.name, :cyclic => true) do |c|
    # parentにはあえてinverse_ofを設定していません。これはtengine_uiでのrails_adminによる
    # 画面表示に問題が発生するためです。
    # またchildrenについてのinverse_ofは必要です。設定しないとDSLのロードが動きません。
    c.embedded_in :parent # , inverse_of: :children
    c.embeds_many :children, :validate => false, inverse_of: :parent
    accepts_nested_attributes_for :children
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

  def template?; true; end
  def runtime?; !template?; end

  class VertexValidations < Mongoid::Errors::Validations
    def translate(key, options)
      ::I18n.translate(
        "#{Mongoid::Errors::MongoidError::BASE_KEY}.validations",
        {:errors => Tengine::Job::Template::Vertex.flatten_errors(document).to_a.join(', ')})
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


  def generate(options = {})
    Tengine::Job::Template::Generator.new.execute(self, options)
  end
end
