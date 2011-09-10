# -*- coding: utf-8 -*-
class Tengine::Core::Event::Finder

  include ::SelectableAttr::Base

  attr_accessor :event_type_name
  attr_accessor :key
  attr_accessor :source_name
  attr_accessor :occurred_at_start
  attr_accessor :occurred_at_end
  attr_accessor :notification_level_ids
  attr_accessor :notification_confirmed
  attr_accessor :sender_name
  attr_accessor :properties

  # 更新間隔 
  attr_accessor :reflesh_interval
  
  # 通知レベル
  multi_selectable_attr :notification_level, :enum => Tengine::Core::Event.notification_level_enum


  def initialize(attrs = {})
    attrs = {
      notification_level_ids: default_notification_level_ids
    }.update(attrs || {})
    attrs.each do |attr, v| 
      send("#{attr}=", v) unless v.blank?
    end
  end

  # デフォルトでは通知レベルがすべて選択された状態にする
  def default_notification_level_ids
    result = []
    Tengine::Core::Event.notification_level_entries.each do |entry|
      result << entry.id
    end
    return result
  end

  def paginate(criteria)
    scope(criteria).page(paginate_options)
  end

  def criteria(criteria)
    scope(criteria)
  end

  def scope(criteria)
    result = criteria
    result = result.where(event_type_name: event_type_name) if event_type_name
    result = result.where(key: key)  if key
    result = result.where(source_name: source_name) if source_name
    result = result.where(:occurred_at.gte => occurred_at_start) if occurred_at_start
    result = result.where(:occurred_at.lte =>  occurred_at_end) if occurred_at_end
    result = result.any_in(notification_level: notification_level_ids) if notification_level_ids
    result = result.where(notification_confirmed: notification_confirmed) if notification_confirmed
    result = result.where(sender_name: sender_name) if sender_name
    result = result.where(properties: properties) if properties
    # ソート
    result = result.asc(:_id)
    result
  end

  def paginate_options
    {:page => page, :per_page => per_page}
  end

end

