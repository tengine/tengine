# -*- coding: utf-8 -*-
require 'tengine/job'

# テンプレートから生成された実行時に使用されるジョブネットを表すVertex。
class Tengine::Job::JobnetActual < Tengine::Job::Jobnet
  include Tengine::Job::ScriptExecutable
  include Tengine::Job::Executable
  include Tengine::Job::Stoppable
  include Tengine::Job::Jobnet::JobStateTransition
  include Tengine::Job::Jobnet::JobnetStateTransition

  field :was_expansion, :type => Boolean # テンプレートがTenigne::Job::Expansionであった場合にtrueです。

  # was_expansionがtrueなら元々のtemplateへの参照が必要なのでRootJobnetActualだけでなく
  # JobnetActualでもtemplateが必要です。
  belongs_to :template, :inverse_of => :root_jobnet_actuals, :index => true, :class_name => "Tengine::Job::RootJobnetTemplate"

  # https://cacoo.com/diagrams/hdLgrzYsTBBpV3Wj#D26C1
  STATE_TRANSITION_METHODS = [:transmit, :activate, :ack, :finish, :succeed, :fail, :fire_stop, :stop, :reset].freeze
  STATE_TRANSITION_METHODS.each do |method_name|
    class_eval(<<-END_OF_METHOD, __FILE__, __LINE__ + 1)
      def #{method_name}(signal, &block)
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

end
