# -*- coding: utf-8 -*-
require 'tengine/job'

# ルートジョブネットとして必要な情報に関するモジュール
module Tengine::Job::RubyJob

  class << self
    attr_accessor :default_conductor
  end

  DEFAULT_CONDUCTOR = proc do |job|
    begin
      job.run
    rescue => e # StandardError以外はTengineの例外として扱います
      job.fail(:exception => e)
    else
      job.succeed
    end
  end
  self.default_conductor = DEFAULT_CONDUCTOR

  class << self
    def run(job, signal, conductor)
      Runner.new(job, signal, conductor).process
    end
  end

  class Runner
    def initialize(job, signal, conductor)
      @job, @signal, @conductor = job, signal, conductor
    end

    def process
      wrapper = JobExecutionWrapper.new(@job)
      @conductor.call(wrapper)
      method_name = (wrapper.result == false) ? :fail : :succeed
      @job.send("ruby_job_#{method_name}", @signal, *wrapper.last_args)
    end
  end

  class JobExecutionWrapper
    attr_reader :source, :last_args, :result

    def initialize(source)
      @source = source
      @last_args = []
      @result = nil
      @started = false
      @done = false
    end

    def run
      return if @started
      @started = true
      ruby_job_block = @source.template_block_for(:ruby_job)
      case ruby_job_block.respond_to?(:arity) ? ruby_job_block.arity : 0
      when 0 then
        ruby_job_block.call
      else
        ruby_job_block.call(self)
      end
    ensure
      @done = true
    end

    def fail(options = {})
      return if @done && !result.nil?
      if exception = options.delete(:exception)
        options[:message] = "[#{exception.class.name}] #{exception.message}\n  " << (exception.backtrace || []).join("\n  ")
      end
      @result = false
      @last_args = [options]
    end

    def succeed(options = {})
      return if @done && !result.nil?
      @result = true
      @last_args = [options]
    end
  end

end
