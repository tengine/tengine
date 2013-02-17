# -*- coding: utf-8 -*-

require 'tengine/job/template'

class Tengine::Job::Template::Generator
  def execute(template, options = {})
    @inherited_attrs = {}
    process(template, options)
  end

  CLASS_MAP = %w[RootJobnet Jobnet Start End Fork Join SshJob].each_with_object({}){|t, d|
    c = "Tengine::Job::Template::#{t}"
    d[c] = c.sub(/Template/, 'Runtime')
  }.update({"Tengine::Job::Template::Expansion" => "Tengine::Job::Runtime::Jobnet"})

  BASE_IGNORED_FIELD_NAMES = ["_type", "_id"].freeze
  EXPANSION_IGNORED_FIELD_NAMES = (BASE_IGNORED_FIELD_NAMES +
    %w[dsl_version jobnet_type_cd version updated_at created_at children edges]).freeze

  def expansion?
    @current.is_a?(Tengine::Job::Template::Expansion)
  end

  def expansion_root
    cond = {:dsl_version => @current.root.dsl_version, :name => @current.name}
    Tengine::Job::Template::RootJobnet.where(cond).first
  end

  def ignored_fields
    expansion? ?
      EXPANSION_IGNORED_FIELD_NAMES : BASE_IGNORED_FIELD_NAMES
  end

  def generating_attrs
    field_names = @current.class.fields.keys - ignored_fields
    attrs = field_names.each_with_object({}){|name, d| d[name] = @current.send(name) }
    if expansion?
      attrs[:was_expansion] = true
      if (t = expansion_root)
        attrs[:template_id] = t.id
      end
    end
    attrs
  end

  def generating_children
    expansion? ?
      expansion_root.children : @current.children
  end

  def generating_edges
    expansion? ?
      expansion_root.edges :
      @current.respond_to?(:edges) ? @current.edges : []
  end

  def process(template, options)
    @inherited_attrs, inherited_attrs_backup = @inherited_attrs.merge(
      @current.nil? ? {} : expansion? ? {} : {
        server_name: @current.actual_server_name,
        credential_name: @current.actual_credential_name,
        killing_signals: @current.actual_killing_signals,
        killing_signal_interval: @current.actual_killing_signal_interval,
      }), @inherited_attrs
    @current, current_backup = template, @current
    begin
      generate(options)
    ensure
      @current = current_backup
      @inherited_attrs = inherited_attrs_backup
    end
  end

  def generate(options)
    attrs = generating_attrs.update(child_index: options[:child_index])
    @inherited_attrs.each{|key, value| attrs[key] ||= value }
    klass_name = CLASS_MAP[@current.class.name]
    result = klass_name.constantize.new(attrs)
    result.save!
    src_to_generated = {}
    generating_children.each.with_index do |child, index|
      generated = process(child, child_index: index + 1)
      src_to_generated[child.id] = generated.id
      result.children << generated
    end
    generating_edges.each do |edge|
      generated = Tengine::Job::Runtime::Edge.new
      generated.origin_id = src_to_generated[edge.origin_id]
      generated.destination_id = src_to_generated[edge.destination_id]
      result.edges << generated
    end
    yield(result) if block_given? # 派生クラスでsave!の前に処理を入れるためのyield
    result.save!
    result
  end

end
