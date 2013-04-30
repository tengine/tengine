# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# Edgeとともにジョブネットを構成するグラフの「頂点」を表すモデルです。
# このクラスだけでツリー構造を作ることができますが、ほぼ抽象クラスであり実際には
# 派生クラスのオブジェクトによってツリー構造が作られます。
class Tengine::Job::Runtime::Vertex
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Job::Structure::NamePath
  include Tengine::Job::Structure::Tree
  include Tengine::Job::Structure::Visitor::Accepter
  include Tengine::Job::Runtime::Signal::Transmittable

  field :child_index, type: Integer

  # self.cyclic = true
  with_options(class_name: self.name, foreign_key: "parent_id") do |c|
    c.belongs_to :parent  , inverse_of: :children
    c.has_many   :children, inverse_of: :parent , validate: false, order: {child_index: 1}
  end

  def template?; false; end
  def runtime?; !template?; end

  def previous_edges
    return nil unless parent
    parent.edges.select{|edge| edge.destination_id == self.id}
  end
  alias_method :prev_edges, :previous_edges

  def next_edges
    return nil unless parent
    parent.edges.select{|edge| edge.origin_id == self.id}
  end

  def ancestors_until_expansion
    if parent = self.parent
      parent.ancestors_until_expansion + [parent]
    else
      []
    end
  end

  # Tengine::Job::Runtime::Vertexは構成されるツリーのルートを保存しても、embedでないので
  # 各vertexをsaveしないと保存されないため、明示的に保存しています。
  def save_descendants!
    accept_visitor(Tengine::Job::Structure::Visitor::All.new{|v| v.save! })
  end
end
