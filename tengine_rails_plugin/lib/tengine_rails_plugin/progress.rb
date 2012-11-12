# encoding: utf-8

require "eventmachine"

module TengineRailsPlugin
  module Progress
    STATUS_TYPES = SelectableAttr::Enum.new do
      name "Tengine進捗状態"
      entry 0, :initial,          "初期状態"
      entry 1, :sended,           "送信済み"
      entry 2, :send_failure,     "送信失敗"
      entry 3, :starting,         "実行中"
      entry 4, :starting_failure, "実行開始失敗"
      entry 5, :error,            "実行失敗"
      entry 6, :success,          "実行成功"
    end

    EVENT_NAME_PREFIX = "tengine.progress."

    def event_name(name)
      "#{EVENT_NAME_PREFIX}#{name}"
    end

    def add_logs(*logs)
      if self.respond_to?(:tengine_logs) and self.respond_to?(:tengine_logs=)
        self.tengine_logs ||= []
        self.tengine_logs += logs
      end
    end

    def set_status(status)
      if self.respond_to?(:status_cd=)
        self.status_cd = status
      end
    end

    def fire(batch_name, options={}, &block)
      add_logs("#{Time.zone.now.rfc2822} sending the event to start")
      set_status(1)
      begin
        properties = { batch_id: self.id, batch_name: batch_name }.update(options || {})
        EventMachine.run do
          Tengine::Event.fire(event_name(batch_name), properties: properties)
        end
      rescue Exception
        add_logs("#{Time.zone.now.rfc2822} #{$!.class.name} #{$!.message}\n  " + $!.backtrace.join("\n  "))
        set_status(2)
        self.save!
        raise
      end
    end

    def self.run(model, event)
      progress = model.find(event[:batch_id])
      progress.extend(self)
      progress.add_logs("#{Time.zone.now.rfc2822} Starting")
      progress.set_status(3)
      progress.save!
      begin
        yield(progress) if block_given?
      rescue
        progress.add_logs("#{Time.zone.now.rfc2822} [#{$!.class.name}] #{$!.message}\n  " + $!.backtrace.join("\n  "))
        progress.set_status(5)
        progress.save!
        raise
      else
        progress.add_logs("#{Time.zone.now.rfc2822} SUCCESS")
        progress.set_status(6)
        progress.save!
      end
    end

    module Driveable
      extend ActiveSupport::Concern

      included do
        include Tengine::Core::Driveable
      end

      module ClassMethods
        def batch(batch_name)
          on "#{EVENT_NAME_PREFIX}#{batch_name}"
        end
      end
    end
  end
end
