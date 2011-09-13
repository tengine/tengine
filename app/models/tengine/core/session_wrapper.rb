# -*- coding: utf-8 -*-
class Tengine::Core::SessionWrapper

  def initialize(source, options = {})
    @options = options || {}
    @source = source
  end

  def system_properties
    @source.system_properties
  end

  def [](key)
    @source.properties[key.to_s]
  end

  def update(properties)
    return if @options[:ignore_update]
    __update__(:properties, properties)
  end

  def system_update(properties)
    __update__(:system_properties, properties)
  end

  private
  def __update__(target_name, properties)
    new_vals = @source.send(target_name).merge(properties.stringify_keys)
    @source.send("#{target_name}=", new_vals)
    @source.save!
  end

end
