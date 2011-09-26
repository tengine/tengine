# -*- coding: utf-8 -*-

# http://mongoid.org/docs/callbacks/observers.html
class Tengine::Resource::Observer < Mongoid::Observer
  prefix = "tengine/resource/"
  observe *%w[physical_server virtual_server virtual_server_image].map{|name| :"#{prefix}#{name}" }

  def after_create(record)
    # puts "created   #{record.class.name}: " << record.attributes.inspect
  end

  def after_update(record)
    # puts "updated   #{record.class.name}: " << record.changes.inspect
  end

  def after_destroy(record)
    # puts "destroyed #{record.class.name}: " << record.attributes.inspect
  end


end
