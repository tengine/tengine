# -*- coding: utf-8 -*-
require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Field
  attr_accessor :__name__, :__parent__, :__type__
  attr_accessor :__block__ # __block__ はactionの具体的な動作を保持します
  attr_accessor :convertor # convertor はfieldの変換ロジックを保持します
  attr_accessor :type, :default_description, :default, :description, :hidden, :enum

  def initialize(attrs = {})
    attrs.each{|k, v| send("#{k}=", v)}
  end

  def field?; @__type__ == :field; end
  def action?; @__type__ == :action; end
  def separator?; @__type__ == :separator; end

  def hidden?; !!self.hidden; end

  def update(attrs)
    attrs.each{|k, v| send("#{k}=", v)}
  end

  def description_value
    [
      __parent__.get_value(description),
      __parent__.get_value(default_description)
    ].join(' ')
  end

  def default_value(context = __parent__)
    default.respond_to?(:to_proc) ? context.instance_eval(&default) : default
  end

  def to_hash
    __parent__.send(__name__) || default_value
  end

  def accept_visitor(visitor)
    visitor.visit(self)
  end

  def name_array
    (__parent__ ? __parent__.name_array : []) + [__name__]
  end

  def root
    __parent__ ? __parent__.root : nil
  end

  def short_opt
    r = root.mapping[ name_array ]
    r ? "-#{r}" : nil
  end

  def long_opt
    '--' << name_array.join('-').gsub(%r{_}, '-')
  end

  def convert(value, context = self)
    return convertor.call(value) if convertor
    result = case self.type
    when :boolean then !!value
    when :integer then value.nil? ? nil : value.to_i
    when :string then value.nil? ? nil : value.to_s
    else value
    end
    result ||= default_value(context)
    if self.enum && !self.enum.include?(result)
      raise ArgumentError, "must be one of #{self.enum.inspect} but was #{result.inspect}"
    end
    result
  end

end
