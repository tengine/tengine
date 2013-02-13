# -*- coding: utf-8 -*-
require 'tengine/job/template'

# 処理を意味するVertex。実際に実行を行うTengine::Job::Scriptやジョブネットである
# Tengine::Job::Jobnetの継承元である。
class Tengine::Job::Template::NamedVertex < Tengine::Job::Template::Vertex

  field :name, :type => String # ジョブの名称。

  validates :name, :presence => true

  # リソース識別子を返します
  def name_as_resource
    @name_as_resource ||= "job:#{Tengine::Event.host_name}/#{Process.pid.to_s}/#{root.id.to_s}/#{id.to_s}"
  end

  def short_inspect
    "#<%%%-30s id: %s name: %s>" % [self.class.name, self.id.to_s, name]
  end

end
