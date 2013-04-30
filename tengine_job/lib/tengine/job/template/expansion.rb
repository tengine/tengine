# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ルートジョブネットを他のジョブネット内に展開するための特殊なテンプレート用Vertex。
class Tengine::Job::Template::Expansion < Tengine::Job::Template::NamedVertex
  def actual_class
    Tengine::Job::Runtime::Jobnet
  end

  def root_jobnet_template
    unless @root_jobnet_template
      cond = {:dsl_version => root.dsl_version, :name => name}
      @root_jobnet_template = Tengine::Job::Template::RootJobnet.where(cond).first
    end
    @root_jobnet_template
  end

  def actual_credential_name
    @root_jobnet_template.actual_credential_name
  end
  def actual_server_name
    @root_jobnet_template.actual_server_name
  end
end
