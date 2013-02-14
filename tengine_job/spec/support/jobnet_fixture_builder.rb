# -*- coding: utf-8 -*-
class JobnetFixtureBuilder

  attr_reader :instances

  def initialize
    reset
  end

  def reset
    @instances = {}
    @start_count = 0
    @end_count = 0
    @fork_count = 0
    @join_count = 0
    @edge_count = 0
  end


  def [](instance_name)
    @instances[instance_name.to_sym]
  end

  def []=(instance_name, instance)
    @instances[instance_name.to_sym] = instance
  end

  def create_template(options = {})
    reset
    @mode = :template
    create(options)
  end

  def create_runtime(options = {})
    template = create_template
    reset
    @mode = :runtime
    options = (options || {}).update(:template => template)
    result = create(options)
    # Tengine::Job::Runtime::Vertexは構成されるツリーのルートを保存しても、embedでないため
    # 各vertexをsaveしないと保存されません。明示的に保存しています。
    result.accept_visitor(Tengine::Job::Structure::Visitor::All.new{|v| v.save! if v.new_record?})
    result
  end
  alias :create_actual :create_runtime

  def context
    self
  end

  def vertex(vertex_name)
    cached = self[vertex_name.to_sym]
    raise ArgumentError, "no vertex found for #{vertex_name.inspect}" unless cached
    self[:root].vertex(cached.id)
  end

  def edge(edge_name)
    cached = self[edge_name.to_sym]
    raise ArgumentError, "no edge found for #{edge_name.inspect}" unless cached
    self[:root].edge(cached.id)
  end

  def create(options = {})
    raise NotImplementedError, "You must use inherited class of FixtureBuilder"
  end

  %w[root_jobnet jobnet ssh_job].each do |method_name|
    root_assign = method_name =~ /^root_/ ? "@instances[:root] = result" : ""

    class_eval(<<-EOS, __FILE__, __LINE__ + 1)
      def new_#{method_name}(name, attrs = {}, &block)
        attrs[:name] = name.to_s
        klass = "Tengine::Job::\#{@mode.to_s.camelize}::#{method_name.camelize}".constantize
        unknown_fields = attrs.keys - klass.fields.keys.map(&:to_sym)
        unknown_fields.each{|f| attrs.delete(f)}
        if klass == Tengine::Job::Template::RootJobnet
          attrs[:dsl_version] ||= Tengine::Core::Setting.dsl_version
        end
        result = klass.new(attrs, &block)
        @instances[name.to_sym] = result
        #{root_assign}
        result
      end
    EOS
  end
  alias :new_script :new_ssh_job

  def new_finally
    klass = "Tengine::Job::#{@mode.to_s.camelize}::Jobnet".constantize
    result = klass.new(:name => "finally", :jobnet_type_key => :finally)
    result
  end

  def new_expansion(name, attrs = {}, &block)
    raise "expansion can be used only as template" unless @mode == :template
    result = Tengine::Job::Template::Expansion.new({:name => name}.update(attrs || {}))
    @instances[name.to_sym] = result
    result
  end


  ABBREVIATES = {
    'start' => 'S',
    'end'   => 'E',
    'fork'  => 'F',
    'join'  => 'J',
  }.freeze

  %w[start end fork join].each do |method_name|
    class_eval(<<-EOS)
      def new_#{method_name}(attrs = {}, &block)
        klass = "Tengine::Job::\#{@mode.to_s.camelize}::#{method_name.camelize}".constantize
        result = klass.new(attrs, &block)
        register_#{method_name}(result)
      end

      def register_#{method_name}(result)
        @#{method_name}_count += 1
        name = ABBREVIATES["#{method_name}"] + @#{method_name}_count.to_s
        @instances[name.to_sym] = result
        result
      end
    EOS
  end

  def new_edge(origin, dest)
    origin_vertex = origin.is_a?(Symbol) ? self[origin] : origin
    dest_vertex   = dest  .is_a?(Symbol) ? self[dest  ] : dest
    raise "no origin vertex found: #{origin.inspect}" unless origin_vertex
    raise "no dest   vertex found: #{dest.inspect  }" unless dest_vertex
    klass = "Tengine::Job::#{@mode.to_s.camelize}::Edge".constantize
    result = klass.new(:origin_id => origin_vertex.id, :destination_id => dest_vertex.id)
    remember_edge(result)
  end

  def remember_edge(edge)
    @edge_count += 1
    name = "e#{@edge_count}"
    @instances[name.to_sym] = edge
    edge
  end

  def check_edge_count(expected)
    raise "edge count error: expected #{expected} but #{@edge_count}" unless @edge_count == expected
  end

end
