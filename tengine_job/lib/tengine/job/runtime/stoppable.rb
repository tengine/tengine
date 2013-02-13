# -*- coding: utf-8 -*-
require 'tengine/job/runtime'
require 'selectable_attr'

# ジョブ／ジョブネットを実行する際の情報に関するモジュール
# Tengine::Job::JobnetActual, Tengine::Job::JobnetTemplateがこのモジュールをincludeします
module Tengine::Job::Runtime::Stoppable
  extend ActiveSupport::Concern

  included do
    field :stopped_at , :type => DateTime # 停止時刻。停止を開始した時刻です。
    field :stop_reason, :type => String   # 停止理由。手動以外での停止ならば停止した理由が設定されます。
  end

  # https://www.pivotaltracker.com/story/show/23329935

  def stop_reason= r
    super
    children.each do |i|
      if i.respond_to?(:chained_box?) && i.chained_box?
        i.stop_reason = r
      end
    end
  end

  def stopped_at= t
    super
    children.each do |i|
      if i.respond_to?(:chained_box?) && i.chained_box?
        i.stopped_at = t
      end
    end
  end

  def fire_stop_event(root_jobnet, options = Hash.new)
    root_jobnet_id = root_jobnet.id.to_s
    result = Tengine::Job::Execution.create!(
      options.merge(:root_jobnet_id => root_jobnet_id))
    properties = {
      :execution_id => result.id.to_s,
      :root_jobnet_id => root_jobnet_id,
      :stop_reason => "user_stop"
    }

    target_id = self.id.to_s
    # if target.children.blank?
    if script_executable?
      event = :"stop.job.job.tengine"
      properties[:target_job_id] = target_id
      properties[:target_jobnet_id] = parent.id.to_s
    else
      event = :"stop.jobnet.job.tengine"
      properties[:target_jobnet_id] = target_id
    end

    EM.run do
      Tengine::Event.fire(event,
        :source_name => name_as_resource,
        :properties => properties)
    end

    return result
  end
end
