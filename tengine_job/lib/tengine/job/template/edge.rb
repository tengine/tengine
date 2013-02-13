# -*- coding: utf-8 -*-
require 'tengine/job/template'
require 'selectable_attr'

# Vertexとともにジョブネットを構成するグラフの「辺」を表すモデル
# Tengine::Job::Jobnetにembeddedされます。
class Tengine::Job::Template::Edge
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tengine::Core::SelectableAttr
  include Tengine::Job::Structure::Visitor::Accepter

  embedded_in :owner, :class_name => "Tengine::Job::Template::Jobnet", :inverse_of => :edges

  field :origin_id     , :type => Moped::BSON::ObjectId # 辺の遷移元となるvertexのid
  field :destination_id, :type => Moped::BSON::ObjectId # 辺の遷移先となるvertexのid

  validates :origin_id, :presence => true
  validates :destination_id, :presence => true

  def origin
    owner.children.detect{|c| c.id == origin_id}
  end

  def destination
    owner.children.detect{|c| c.id == destination_id}
  end

  def name_for_message
    "edge(#{id.to_s}) from #{origin ? origin.name_path : 'no origin'} to #{destination ? destination.name_path : 'no destination'}"
  end

  def inspect
    "#<#{self.class.name} #{name_for_message}>"
  end

end
