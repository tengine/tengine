# -*- coding: utf-8 -*-
require 'tengine/job/root_jobnet_actual'

class Tengine::Job::RootJobnetActual::Finder

  ATTRIBUTE_NAMES = [
    :time,
    :started_at,
    :finished_at,
    :id,
    :name,
    :phase_ids,
    :reflesh_interval, # 更新間隔
  ].freeze

  ATTRIBUTE_NAMES.each{|name| attr_accessor(name) }

  include Tengine::Core::SelectableAttr

  multi_selectable_attr :phase_cd, :enum => Tengine::Job::RootJobnetActual.phase_enum

  def initialize(attrs = {})
    now = Time.now
    attrs = {
      started_at:  now.beginning_of_day,
      finished_at: now.end_of_day,
      phase_ids:   Tengine::Job::RootJobnetActual.phase_ids,
    }.update(attrs || {})
    attrs.each do |attr, v|
      send("#{attr}=", v) unless v.nil?
    end
  end

  def attributes
    ATTRIBUTE_NAMES.inject({}){|d, name| d[name] = send(name); d }
  end
end
