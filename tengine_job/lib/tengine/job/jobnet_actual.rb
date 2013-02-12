# -*- coding: utf-8 -*-
require 'tengine/job'

# テンプレートから生成された実行時に使用されるジョブネットを表すVertex。
class Tengine::Job::JobnetActual < Tengine::Job::Jobnet
  include Tengine::Job::ScriptExecutable
  include Tengine::Job::Executable
  include Tengine::Job::Stoppable
  include Tengine::Job::Jobnet::JobStateTransition
  include Tengine::Job::Jobnet::JobnetStateTransition
  include Tengine::Job::Jobnet::RubyJobStateTransition

  field :was_expansion, :type => Boolean # テンプレートがTenigne::Job::Expansionであった場合にtrueです。

  # was_expansionがtrueなら元々のtemplateへの参照が必要なのでRootJobnetActualだけでなく
  # JobnetActualでもtemplateが必要です。
  belongs_to :template, :inverse_of => :root_jobnet_actuals, :index => true, :class_name => "Tengine::Job::RootJobnetTemplate"

  # https://cacoo.com/diagrams/hdLgrzYsTBBpV3Wj#D26C1
  STATE_TRANSITION_METHODS = [:transmit, :activate, :ack, :finish, :succeed, :fail, :fire_stop, :stop, :reset].freeze
  STATE_TRANSITION_METHODS.each do |method_name|
    class_eval(<<-END_OF_METHOD, __FILE__, __LINE__ + 1)
      def #{method_name}(signal, &block)
        jobnet_type_key == :ruby_job ?
          ruby_job_#{method_name}(signal, &block) :
        script_executable? ?
          job_#{method_name}(signal, &block) :
          jobnet_#{method_name}(signal, &block)
      end
    END_OF_METHOD
  end

  def root_or_expansion
    p = parent
    p.nil? ? self : p.was_expansion ? p : p.root_or_expansion
  end

  def template_block_for(block_name)
    key = Tengine::Job::DslLoader.template_block_store_key(self, block_name)
    result = Tengine::Job::DslLoader.template_block_store[key]
    return result if result
    template_root = root_or_expansion.template
    return nil unless template_root
    template_job = template_root.vertex_by_name_path(self.name_path_until_expansion)
    unless template_job
      raise "job not found #{self.name_path_until_expansion.inspect} in #{template_root.inspect}"
    end
    template_job.template_block_for(block_name)
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
