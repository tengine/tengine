# -*- coding: utf-8 -*-
require 'tengine/event'

# activemodelなどのObserverの仕組みを使ってイベントキューにモデルの
# 登録、変更、削除を通知するための実装を提供するモジュールです。
#
# http://guides.rubyonrails.org/active_record_validations_callbacks.html#observers
# http://mongoid.org/docs/callbacks/observers.html
module Tengine::Event::ModelNotifiable
  def after_create(record)
    fire_event(:created, record)
  end

  def after_update(record)
    fire_event(:updated, record)
  end

  def after_destroy(record)
    fire_event(:destroyed, record)
  end

  private
  def fire_event(event_base, record)
    event_properties = {
      :class_name => record.class.name,
      :attributes => record.attributes
    }
    if event_base == :updated
      event_properties[:changes] = record.changes
    end
    event_sender.fire(event_type_name(event_base, record),
      :level_key => :info,
      :properties => event_properties
      )
  end

  # def event_sender
  #   raise NotImplementedError
  # end

  def event_type_name(event_base, record)
    "#{record.class.name}.#{event_base}.#{event_type_name_suffix}"
  end

  def event_type_name_suffix
    self.class.name
  end

end
