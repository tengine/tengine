# -*- coding: utf-8 -*-
require 'tengine/core'

class Tengine::Core::DslFilterDef
  attr_reader :filter
  attr_reader :event_type_names
  def initialize(event_type_names, filter)
    @event_type_names = event_type_names
    @filter = filter
  end

  BRACE_FORMAT = 's_%s_e'.freeze # メソッド名にはカッコが使えないので変わりに表現する方法として(と)をそれぞれs_と_eで表します。

  FORMATTERS = {
    :and => lambda{|event_type_names, filter| "%s_and_%s" % event_type_names },
    :at  => lambda{|event_type_names, filter| "%s_at_%s" % [event_type_names.first, filter['pattern'].to_s] },
  }

  def to_method_name
    event_type_name_args =
      event_type_names.map{|obj| obj.is_a?(Tengine::Core::DslFilterDef) ? obj.to_method_name : obj.to_s}
    formatter = FORMATTERS[ filter['type'] ]
    BRACE_FORMAT % formatter.call(event_type_name_args, filter)
  end

  class << self
    def new_and(left, right)
      Tengine::Core::DslFilterDef.new(
        [left, right],
        {
          'type' => :and,
          'method' => :and,
          'children' => [
            { 'pattern' => left, 'method' => :find_or_mark_in_session },
            { 'pattern' => right, 'method' => :find_or_mark_in_session },
          ]
        })
    end

    def new_at(event_type_name, source_pattern)
      Tengine::Core::DslFilterDef.new(
        [event_type_name],
        {
          'type' => :at,
          'method' => :match_source_name?,
          'pattern' => source_pattern.to_s,
        })
    end

  end
end
