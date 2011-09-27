# -*- coding: utf-8 -*-

# http://mongoid.org/docs/callbacks/observers.html
class Tengine::Resource::Observer < Mongoid::Observer
  include Tengine::Event::ModelNotifiable

  prefix = "tengine/resource/"
  observe *%w[physical_server virtual_server virtual_server_image].map{|name| :"#{prefix}#{name}" }

  def event_sender
    yaml_path = File.expand_path("../../../../config/tengined.yml", File.dirname(__FILE__))
    config = YAML.load_file(yaml_path)
    @event_sender = Tengine::Event::Sender.new(
      Tengine::Mq::Suite.new(config['event_queue']))
  end

  SUFFIX = "tengine_resource_watchd".freeze

  def event_type_name_suffix
    SUFFIX
  end

end
