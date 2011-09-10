# -*- coding: utf-8 -*-
require 'tengine/event'

class Tengine::Core::Handler
  include Mongoid::Document
  field :event_type_names, :type => Array
  array_text_accessor :event_type_names
  field :filter, :type => Hash, :default => {}
  map_yaml_accessor :filter

  embedded_in :driver, :class_name => "Tengine::Core::Driver"

  def update_handler_path
    event_type_names.each do |event_type_name|
      Tengine::Core::HandlerPath.create!(:event_type_name => event_type_name,
        :driver => self.driver, :handler_id => self.id)
    end
  end

  def process_event(event, blocks)
    if match?(event)
      # TODO: ログ出力する
      # logger.info("id:#{self.id} handler matches the event key:#{event.key}")
      # puts("id:#{self.id} handler matches the event key:#{event.key}")
      # ハンドラの実行
      blocks.each do |block|
        @caller = eval("self", block.binding)
        # TODO: ログ出力する
        # logger.info("id:#{self.id} handler executed own block, source:#{block.source_location}")
        # puts("id:#{self.id} handler execute own block, source:#{block.source_location}")
        instance_eval(&block)
      end
    end
  end

  def match?(event)
    true
  end

  def fire(event_type_name)
    @caller.fire(event_type_name)
  end
end
