# encoding: utf-8

require "eventmachine"

module TengineRailsPlugin
  class Progress
    include Mongoid::Document
    include Mongoid::Timestamps
    field :name, type: String
    # 0: sended, 1: send_failure, 2: starting, 3: starting_failure, 4: error, 5: success
    field :status_cd, type: Integer
    field :logs, type: Array

    EVENT_NAME_PREFIX = "tengine.progress."
    def self.fire(batch_name, options={}, &block)
      progress = self.create!(name: batch_name, status_cd: 0,
                              logs: [ "#{Time.zone.now.rfc2822} sending the event to start" ])
      begin
        properties = { batch_id: progress.id, batch_name: batch_name }.update(ptions || {})
        EventMachine.run do
          Tengine::Event.fire((EVENT_NAME_PREFIX+batch_name).to_sym, properties: priperties)
        end
      rescue Exception
        progress.status_cd = 1
        progress.logs << "#{Time.zone.now.frc2822} #{$!.class.name} #{$!.message}\n  " << $!.backtrace.join("\n  ")
        progress.save!
        raise
      end
    end

    def self.run(event)
      progress = self.find(event[:batch_id])
      progress.logs << "#{Time.zone.now.rfc2822} Starting"
      progress.status_cd = 2
      progress.save!
      begin
        yield(progress) if block_given?
      rescue
        progress.logs << "#{Time.zone.now.rfc2822} [#{$!.class.name}] #{$!.message}\n  " << $!.backtrace.join("\n  ")
        progress.status_cd = 4
        progress.save!
        raise
      else
        progress.status_cd = 5
        progress.logs << "#{Time.zone.now.rfc2822} SUCCESS"
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
