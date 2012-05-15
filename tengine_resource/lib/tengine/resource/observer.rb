# -*- coding: utf-8 -*-
require 'mongoid'

require 'yaml'
require 'tengine_event'
require 'tengine/support/yaml_with_erb'

# http://mongoid.org/docs/callbacks/observers.html
class Tengine::Resource::Observer < Mongoid::Observer
  include Tengine::Event::ModelNotifiable

  prefix = "tengine/resource/"
  observe *%w[physical_server virtual_server virtual_server_image virtual_server_type].map{|name| :"#{prefix}#{name}" }

  def event_sender
    @event_sender = Tengine::Event.default_sender
  end

  SUFFIX = "tengine_resource_watchd".freeze

  def event_type_name_suffix
    SUFFIX
  end

end
