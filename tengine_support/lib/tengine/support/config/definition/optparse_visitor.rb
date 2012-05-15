# -*- coding: utf-8 -*-
require 'tengine/support/config/definition'

require 'optparse' # ここ以外でrequireしないし、関係するクラスを記述しません。

class Tengine::Support::Config::Definition::OptparseVisitor

  attr_reader :option_parser
  def initialize(suite)
    @option_parser = OptionParser.new
    @suite = suite
  end

  alias_method :o, :option_parser

  def visit(d)
    return if d.respond_to?(:hidden?) && d.hidden?
    case d
    when Tengine::Support::Config::Definition::Suite then
      option_parser.banner = d.banner
      d.children.each{|child| child.accept_visitor(self)}
    when Tengine::Support::Config::Definition::Group then
      if d.children.any?{|c| c.is_a?(Tengine::Support::Config::Definition::Field)}
        o.separator ""
        o.separator "#{d.__name__}:"
      end
      d.children.each{|child| child.accept_visitor(self)}
    when Tengine::Support::Config::Definition then
      o.separator ""
      o.separator "#{d.__name__}:"
      d.children.each{|child| child.accept_visitor(self)}
    when Tengine::Support::Config::Definition::Field then
      desc = d.description_value
      desc_str  = desc.respond_to?(:call) ? desc.call : desc
      long_opt = d.long_opt
      args = [d.short_opt, long_opt, desc_str].compact
      case d.__type__
      when :action then
        obj = eval("self", d.__block__.binding)
        (class << obj; self; end).module_eval do
          attr_accessor :option_parser
        end
        obj.option_parser = option_parser
        o.on(*args, &d.__block__)
      when :separator then
        o.separator(d.description)
      else
        case d.type
        when :boolean then
          o.on(*args){d.__parent__.send("#{d.__name__}=", true)}
        when :load_config then
          long_opt << "=VAL"
          o.on(*args){|f| d.__parent__.send("#{d.__name__}=", f) }
        else
          long_opt << "=VAL"
          if d.enum
            desc_str << " must be one of " << (d.enum.join(',').gsub(/\A\[|\]\Z/, ''))
          end
          if default_value = d.default_value
            desc_str << " default: #{default_value.inspect}"
          end
          o.on(*args){|val| d.__parent__.send("#{d.__name__}=", val)}
        end
      end
    else
      raise "Unsupported definition class #{d.class.name}"
    end

  end
end
