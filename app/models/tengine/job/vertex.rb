# -*- coding: utf-8 -*-
class Tengine::Job::Vertex
  include Mongoid::Document

  self.cyclic = true
  with_options(:class_name => self.name, :cyclic => true) do |c|
    c.embedded_in :parent  , :inverse_of => :children
    c.embeds_many :children, :inverse_of => :parent
  end

  def short_inspect
    "#<%%%-30s id: %s>" % [self.class.name, self.id.to_s]
  end
  alias_method :long_inspect, :inspect
  alias_method :inspect, :short_inspect

end
