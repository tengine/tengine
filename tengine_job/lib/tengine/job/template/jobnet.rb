# -*- coding: utf-8 -*-
require 'tengine/job/template'

require 'selectable_attr'

# ジョブの始端から終端までを持ち、VertexとEdgeを組み合わせてジョブネットを構成することができるVertex。
# 自身もジョブネットを構成するVertexの一部として扱われる。
class Tengine::Job::Template::Jobnet < Tengine::Job::Template::NamedVertex
  include Tengine::Core::SelectableAttr
  include Tengine::Core::SafeUpdatable

  include Tengine::Job::Structure::JobnetBuilder
  include Tengine::Job::Structure::JobnetFinder
  include Tengine::Job::Structure::ElementSelectorNotation

  include Tengine::Job::Template::SshJob::Settings

  autoload :Builder, "tengine/job/jobnet/builder"
  autoload :StateTransition, 'tengine/job/jobnet/state_transition'
  autoload :JobStateTransition, 'tengine/job/jobnet/job_state_transition'
  autoload :JobnetStateTransition, 'tengine/job/jobnet/jobnet_state_transition'

  field :description   , :type => String # ジョブネットの説明

  field :jobnet_type_cd, :type => Integer, :default => 1 # ジョブネットの種類。後述の定義を参照してください。

  selectable_attr :jobnet_type_cd do
    entry 1, :normal        , "normal"
    entry 2, :finally       , "finally", :alternative => true
    # entry 3, :recover       , "recover", :alternative => true
    entry 4, :hadoop_job_run, "hadoop job run"
    entry 5, :hadoop_job    , "hadoop job"    , :chained_box => true
    entry 6, :map_phase     , "map phase"     , :chained_box => true
    entry 7, :reduce_phase  , "reduce phase"  , :chained_box => true
  end
  def chained_box?; jobnet_type_entry[:chained_box]; end

  embeds_many :edges, :class_name => "Tengine::Job::Template::Edge", :inverse_of => :owner , :validate => false

  before_validation do |r|
    r.edges.each do |edge|
      unless edge.valid?
        edge.errors.each do |f, error|
          r.errors.add(:base, "#{edge.name_for_message} #{f.to_s.humanize} #{error}")
        end
      end
    end
  end

  class << self
    def by_name(name)
      where({:name => name}).first
    end

    {
      vertex: "Vertex",
      start_vertex: "Start",
      end_vertex: "End",
      jobnet: "Jobnet",
    }.each do |key, value|
      instance_eval("def #{key}_class; \"Tengine::Job::Template::#{value}\"; end")
    end
  end
end




# ジョブネットの始端を表すVertex。特に状態は持たない。
class Tengine::Job::Template::Start < Tengine::Job::Template::Vertex
end


# ジョブネットの終端を表すVertex。特に状態は持たない。
class Tengine::Job::Template::End < Tengine::Job::Template::Vertex
end
