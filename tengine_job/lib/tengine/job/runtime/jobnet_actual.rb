# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# テンプレートから生成された実行時に使用されるジョブネットを表すVertex。
class Tengine::Job::Runtime::JobnetActual < Tengine::Job::Jobnet

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


end
