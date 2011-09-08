# -*- coding: utf-8 -*-
class Tengine::Core::Session
  include Mongoid::Document
  field :properties, :type => Hash
  map_yaml_accessor :properties

  belongs_to :driver, :index => true, :class_name => "Tengine::Core::Driver"

  # 元々の[]と[]=メソッドをオーバーライドしているので要注意
  def [](key); properties[key]; end
  def []=(key, value); properties[key] = value; end

end
