# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ルートジョブネットを他のジョブネット内に展開するための特殊なテンプレート用Vertex。
class Tengine::Job::Template::Expansion < Tengine::Job::Template::NamedVertex
  def actual_class
    Tengine::Job::JobnetActual
  end
  def root_jobnet_template
    unless @root_jobnet_template
      cond = {:dsl_version => root.dsl_version, :name => name}
      @root_jobnet_template = Tengine::Job::RootJobnetTemplate.where(cond).first
    end
    @root_jobnet_template
  end

  IGNORED_FIELD_NAMES = (Tengine::Job::Vertex::IGNORED_FIELD_NAMES + %w[name dsl_version jobnet_type_cd version updated_at created_at children edges]).freeze

  def generating_attrs
    result = super
    attrs = root_jobnet_template.attributes.dup
    if template = root_jobnet_template
      attrs[:template_id] = template.id
    end
    attrs.delete_if{|attr, value| IGNORED_FIELD_NAMES.include?(attr)}
    result.update(attrs)
    result
  end
  def generating_children; root_jobnet_template.children; end
  def generating_edges; root_jobnet_template.edges; end

  def generate(klass = actual_class)
    result = super
    result.was_expansion = true
    result
  end
end
