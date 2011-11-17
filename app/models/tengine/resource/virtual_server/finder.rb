# -*- coding: utf-8 -*-
require 'tengine/resource/virtual_server'

class Tengine::Resource::VirtualServer::Finder
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  ATTRIBUTE_NAMES = [
    :physical_server_name, # 部分一致
    :virtual_server_name, # 部分一致
    :provided_id, # 完全一致
    :description, # 部分一致
    :virtual_server_image_name, # 部分一致
    :status_ids, # or
  ].freeze

  ATTRIBUTE_NAMES.each{|name| attr_accessor(name) }
  
  #include Tengine::Core::SelectableAttr
  include ::SelectableAttr::Base

  multi_selectable_attr :status_cd do
    entry 50, :starting     , "starting"
    entry 60, :running      , "running"
    entry 70, :shuttingdown , "shuttingdown"
    entry 40, :terminated   , "terminated"
  end

  def initialize(attrs={})
    attrs = {
      status_ids: Tengine::Resource::VirtualServer::Finder.status_ids,
    }.update(attrs || {})
    ATTRIBUTE_NAMES.each do |attr|
      v = attrs[attr]
      send("#{attr}=", v) unless v.nil?
    end
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
