# -*- coding: utf-8 -*-
require 'tengine/job/root_jobnet_actual'

class Tengine::Job::RootJobnetActual::Finder
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  ATTRIBUTE_NAMES = [
    :duration,
    :duration_start,
    :duration_finish,
    :id,
    :name,
    :phase_ids,
    :reflesh_interval, # 更新間隔
  ].freeze

  ATTRIBUTE_NAMES.each{|name| attr_accessor(name) }

  #include Tengine::Core::SelectableAttr
  include ::SelectableAttr::Base

  multi_selectable_attr :phase_cd, :enum => Tengine::Job::RootJobnetActual.phase_enum

  def initialize(attrs = {})
    now = Time.now
    attrs = assign_attributes(attrs)
    attrs = {
      duration: "started_at",
      duration_start:  now.beginning_of_day,
      duration_finish: now.end_of_day,
      phase_ids:   Tengine::Job::RootJobnetActual.phase_ids,
    }.update(attrs || {})
    ATTRIBUTE_NAMES.each do |attr|
      v = attrs[attr]
      send("#{attr}=", v) unless v.nil?
    end
  end

  def attributes
    ATTRIBUTE_NAMES.inject({}){|d, name| d[name] = send(name); d }
  end

  #validate :validate_datetime

  def persisted?
    false
  end

  # 時間の設定
  def assign_attributes(attrs = {})
    _attrs = {}
    return _attrs if attrs.nil?
    ATTRIBUTE_NAMES.each do |key|
      unless [:duration_start, :duration_finish].include?(key)
        _attrs[key] = attrs[key] unless attrs[key].nil?
      else
        # 年・月・日の場合、「0」は無効。時・分の場合、「0」は有効。
        time__attrs = attrs.select{|_, v| _ =~ /\A#{key}/}.sort.map.with_index{|(_, v), _i| v.blank? ? nil : ((i = v.to_i).zero? && [0, 1, 2].include?(_i) ? nil : i)}.take_while{|_| !_.nil?}

        unless time__attrs.blank?
          begin
            time = Time.local(*time__attrs)
          rescue
          else
            _attrs[key] = time
          end
        end
      end
    end
    return _attrs
  end

  def scope(criteria)
    finder = {}
    [:id, :name].each do |field|
      next if (value = self.send(field)).blank?
      if field.to_s == "id"
        finder[:_id] = value
      else
        value = /#{Regexp.escape(value)}/
        finder[field] = value
      end
    end
    criteria = criteria.where(finder)

    unless (phase_ids = self.phase_ids).blank?
      criteria = criteria.any_in({:phase_cd => phase_ids})
    end

    unless (duration = self.duration).nil?
      duration = duration.to_sym
      if [:started_at, :finished_at].include?(duration)
        criteria = criteria.where({duration.send("gte") => self.duration_start})
        criteria = criteria.where({duration.send("lte") => self.duration_finish})
      end
    end
    return criteria
  end

  private

  # 時間の検証
  def validate_datetime
    unless duration_start.is_a?(Time)
      errors.add :duration_start, I18n.t(
        :invalid, :scope => 'activerecord.errors.messages')
      return
    end
    unless duration_finish.is_a?(Time)
      errors.add :duration_finish, I18n.t(
        :invalid, :scope => 'activerecord.errors.messages')
      return
    end
  end
end
