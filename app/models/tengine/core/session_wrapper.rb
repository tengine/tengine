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

  def update(properties, &block)
    return if @options[:ignore_update]
    __update__(:properties, properties, &block)
  end

  def system_update(properties, &block)
    __update__(:system_properties, properties, &block)
  end

  private
  def __update__(target_name, properties, &block)
    new_vals = __get_properties__(target_name).merge(properties.stringify_keys)
    @source.send("#{target_name}=", new_vals)
    @source.save!
  end

  # テストで同時に値を取得したことを再現するために、
  # データを取得するメソッドで待ち合わせするフックとなるようにメソッドに分けています
  def __get_properties__(target_name, reload = false)
    @source.reload if reload
    @source.send(target_name)
  end


end
