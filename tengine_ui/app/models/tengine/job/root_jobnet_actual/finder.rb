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
    :refresh_interval, # 更新間隔
  ].freeze

  ATTRIBUTE_NAMES.each{|name| attr_accessor(name) }

  validate :validate_datetime

  include Tengine::Core::SelectableAttr

  multi_selectable_attr :phase_cd, :enum => Tengine::Job::RootJobnetActual.phase_enum

  DEFAULT_REFRESH_INTERVAL = 15

  def initialize(attrs = {})
    now = Time.now
    attrs = assign_attributes(attrs)
    attrs = {
      duration: "started_at",
      duration_start:  now.beginning_of_day,
      duration_finish: now.end_of_day,
      phase_ids:   Tengine::Job::RootJobnetActual.phase_ids,
      refresh_interval: DEFAULT_REFRESH_INTERVAL,
    }.update(attrs || {})
    ATTRIBUTE_NAMES.each do |attr|
      v = attrs[attr]
      send("#{attr}=", v) unless v.nil?
    end
    self.refresh_interval = 0 if refresh_interval.to_i < 0
  end

  def attributes
    ATTRIBUTE_NAMES.inject({}){|d, name| d[name] = send(name); d }
  end

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
        time__attrs = attrs.select{|_, v| _ =~ /\A#{key}/}.sort.
          map.with_index{|(_, v), _i| v.blank? ? nil :
            ((i = v.to_i).zero? && [0, 1, 2].include?(_i) ? nil : i)}.
            take_while{|_| !_.nil?}

        unless time__attrs.blank?
          begin
            time = Time.new(*time__attrs)
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
    criteria = criteria.where({:_id => id}) unless id.blank?
    criteria = criteria.where({:name => /#{Regexp.escape(name)}/}) unless name.blank?
    criteria = criteria.any_in({:phase_cd => phase_ids}) unless phase_ids.blank?
    unless duration.blank?
      _duration = duration.to_sym
      if [:started_at, :finished_at].include?(_duration)
        criteria = criteria.where({_duration.send("gte") => duration_start})
        criteria = criteria.where({_duration.send("lte") => duration_finish})
      end
    end
    return criteria
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  class << self
    def human_name
      I18n.t("mongoid.models.#{self.model_name.i18n_key}")
    end

    def human_attribute_name(attr, options = {})
      I18n.t("mongoid.attributes.#{self.model_name.i18n_key}.#{attr}")
    end

    def lookup_ancestors
      [self]
    end
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

    if duration_start > duration_finish
      errors.add :duration_start, I18n.t(:less_than,
        :scope => 'activerecord.errors.messages',
        :count => duration_finish,
      )
    end

    now = Time.now
    if duration_start > now && duration_finish > now
      errors.add :duration_start, I18n.t(:less_than,
        :scope => 'activerecord.errors.messages',
        :count => now,
      )
      errors.add :duration_finish, I18n.t(:less_than,
        :scope => 'activerecord.errors.messages',
        :count => now,
      )
    end
  end
end
