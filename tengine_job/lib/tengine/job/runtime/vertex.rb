# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# Edgeとともにジョブネットを構成するグラフの「頂点」を表すモデル
# 自身がツリー構造を
class Tengine::Job::Runtime::Vertex
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Job::Structure::NamePath
  include Tengine::Job::Structure::Tree
  include Tengine::Job::Structure::Visitor::Accepter

  self.cyclic = true
  with_options(:class_name => self.name, :cyclic => true) do |c|
    c.belongs_to :parent  , :inverse_of => :children
    c.has_many   :children, :inverse_of => :parent , :validate => false
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

  def ancestors_until_expansion
    if (parent = self.parent) && !self.was_expansion?
      parent.ancestors_until_expansion + [parent]
    else
      []
    end
  end


end
