# -*- coding: utf-8 -*-
require 'tengine/resource/virtual_server'

class Tengine::Resource::VirtualServer::Finder
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  ATTRIBUTE_NAMES = [
    :physical_server_name,
    :virtual_server_name,
    :provided_id,
    :description,
    :virtual_server_image_name,
    :status_ids,
  ].freeze
  DEFAULT_ORDER = [[:name, :asc]]

  ATTRIBUTE_NAMES.each{|name| attr_accessor(name) }

  include Tengine::Core::SelectableAttr

  multi_selectable_attr :status_cd do
    Tengine::Resource::Provider::Wakame::VIRTUAL_SERVER_STATES.each do |status|
      entry status, status, status.to_s
    end
  end

  def initialize(attrs={})
    attrs = attrs[:finder] if attrs.has_key?(:finder)
    ATTRIBUTE_NAMES.each do |attr|
      v = attrs[attr]
      send("#{attr}=", v) unless v.nil?
    end
  end

  def finded_by_virtual_server?
    bool = false
    bool = true unless virtual_server_name.blank?
    bool = true unless provided_id.blank?
    bool = true unless description.blank?
    bool = true unless virtual_server_image_name.blank?
    bool = true unless status_ids.blank?
    return bool
  end

  # criteria is the Tengine::Resource::VirtualServer
  def scope(criteria)
    unless virtual_server_name.blank?
      criteria = criteria.where(:name => /^#{virtual_server_name}/)
    end
    unless provided_id.blank?
      criteria = criteria.where(:provided_id => provided_id)
    end
    unless description.blank?
      criteria = criteria.where(:description => /#{description}/)
    end
    criteria = criteria.any_in(:status => status_ids) unless status_ids.blank?
    unless virtual_server_image_name.blank?
      images = Tengine::Resource::VirtualServerImage.where(
        :name => /#{virtual_server_image_name}/)
      unless images.blank?
        criteria = criteria.any_in(:provided_image_id => images.collect(&:provided_id))
      else
        # 条件に一致するVirtualServerImageが1つもないためどのVirtualServerも条件に
        # 一致しない
        criteria = criteria.where(:_id => 0)
      end
    end

    return criteria.order_by(DEFAULT_ORDER)
  end

  def attributes
    ATTRIBUTE_NAMES.inject({}){|d, name| d[name] = send(name); d }
  end

  def persisted?
    false
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  class << self
    def human_attribute_name(attr, options = {})
      I18n.t("mongoid.attributes.#{self.model_name.i18n_key}.#{attr}")
    end

    def lookup_ancestors
      [self]
    end
  end
end
