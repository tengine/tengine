# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# DSLを評価して登録されるルートジョブネットを表すVertex
class Tengine::Job::Runtime::RootJobnet < Tengine::Job::Runtime::Jobnet

  belongs_to :category, :inverse_of => :runtime_root_jobnets, :index => true, :class_name => "Tengine::Job::Structure::Category"

  has_many :executions, :inverse_of => :root_jobnet, :class_name => "Tengine::Job::Runtime::Execution"

  def execute(options = {})
    event_sender = options.delete(:sender) || Tengine::Event.default_sender
    actual = generate
    actual.with(safe: safemode(actual.class.collection)).save!
    result = Tengine::Job::Execution.with(
                safe: safemode(Tengine::Job::Execution.collection)
             ).create!(
               (options || {}).update(:root_jobnet_id => actual.id)
             )
    event_sender.fire(:"start.execution.job.tengine", :properties => {
        :execution_id => result.id,
        :root_jobnet_id => actual.id,
        :target_jobnet_id => actual.id
      })
    result
  end

  def rerun(*args)
    options = args.extract_options!
    sender = options.delete(:sender) || Tengine::Event.default_sender
    options = options.merge({
        :retry => true,
        :root_jobnet_id => self.id,
      })
    result = Tengine::Job::Execution.new(options)
    result.target_actual_ids ||= []
    result.target_actual_ids += args.flatten
    result.with(safe: safemode(Tengine::Job::Execution.collection)).save!
    sender.wait_for_connection do
      sender.fire(:'start.execution.job.tengine', :properties => {
          :execution_id => result.id.to_s
        })
    end
    result
  end

  def update_with_lock(*args)
    super(*args) do
      Tengine::Job.test_harness_hook("before yield in update_with_lock")
      yield if block_given?
      Tengine::Job.test_harness_hook("after yield in update_with_lock")
    end
    Tengine::Job.test_harness_hook("after update_with_lock")
  end

  def fire_stop_event(options = Hash.new)
    root_jobnet_id = self.id.to_s
    result = Tengine::Job::Execution.create!(
      options.merge(:root_jobnet_id => root_jobnet_id))

    EM.run do
      Tengine::Event.fire(:"stop.jobnet.job.tengine",
        :source_name => name_as_resource,
        :properties => {
          :execution_id => result.id.to_s,
          :root_jobnet_id => root_jobnet_id,
          :target_jobnet_id => root_jobnet_id.to_s,
          :stop_reason => "user_stop",
        })
    end

    return result
  end

  def find_duplication
    return nil unless self.new_record?
    self.class.find_by_name(name, :version => self.dsl_version)
  end

  class << self
    # Tengine::Core::FindByName で定義しているクラスメソッドfind_by_nameを上書きしています
    def find_by_name(name, options = {})
      version = options[:version] || Tengine::Core::Setting.dsl_version
      where({:name => name, :dsl_version => version}).first
    end
  end
end
