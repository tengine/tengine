# -*- coding: utf-8 -*-
require 'tengine/job/dsl'

# ジョブDSLをロードする際に使用される語彙に関するメソッドを定義するモジュール
module Tengine::Job::Dsl::Loader
  include Tengine::Job::Dsl::Evaluator

  class << self
    def loading_template_block_store
      @loading_template_block_store ||= {}
    end

    def template_block_store
      @template_block_store ||= {}
    end

    def template_block_store_key(job, name)
      "#{job.root.id.to_s}/#{job.id.to_s}##{name}"
    end

    def update_loaded_blocks(loaded_root)
      if loaded_root
        loading_template_block_store.each do |unsaved_job, (name, block)|
          loaded_job = loaded_root.vertex_by_name_path(unsaved_job.name_path)
          key = template_block_store_key(loaded_job, name)
          template_block_store[key] = block
        end
      else
        loading_template_block_store.each do |saved_job, (name, block)|
          key = template_block_store_key(saved_job, name)
          template_block_store[key] = block
        end
      end
      loading_template_block_store.clear
    end
  end


  def jobnet(name, *args, &block)
    options = args.extract_options!
    options[:description] = options.delete(:caption) if options[:caption]
    options = {
      :name => name,
      :description => args.first || name,
    }.update(options)
    auto_sequence = options.delete(:auto_sequence)
    result = __with_redirection__(options) do
      if @jobnet.nil?
        klass = Tengine::Job::Template::RootJobnet
        options[:dsl_version] = config.dsl_version
        path, lineno = *block.source_location
        options[:dsl_filepath] = config.relative_path_from_dsl_dir(path)
        options[:dsl_lineno] = lineno.to_i
      else
        klass = Tengine::Job::Template::Jobnet
      end
      klass.new(options)
    end
    result.with_start
    @jobnet.children << result if @jobnet
    if result.parent.nil?
      if duplicated = result.find_duplication
        if (duplicated.dsl_filepath != result.dsl_filepath) ||
            (duplicated.dsl_lineno != result.dsl_lineno)
          raise Tengine::Job::Dsl::Error, "2 jobnet named #{name.inspect} found at #{duplicated.dsl_filepath}:#{duplicated.dsl_lineno} and #{result.dsl_filepath}:#{result.dsl_lineno}"
        end
      end
    end

    __stack_instance_variable__(:@auto_sequence,  auto_sequence || @auto_sequence) do
      __stack_instance_variable__(:@boot_job_names,  []) do
        __stack_instance_variable__(:@redirections,  []) do
          __stack_instance_variable__(:@jobnet, result, &block)
          result.build_edges(@auto_sequence, @boot_job_names, @redirections)
        end
      end
    end
    if result.parent.nil?
      loaded = result.find_duplication
      result.save! unless loaded
      Tengine::Job::Dsl::Loader.update_loaded_blocks(loaded)
      loaded || result
    else
      result
    end
  end

  def auto_sequence
    @auto_sequence = true
  end

  def boot_jobs(*boot_job_names)
    @auto_sequence = false
    @boot_job_names = boot_job_names
  end

  def job(name, *args)
    script, description, options = __parse_job_args__(name, args)
    options[:description] = options.delete(:caption) if options[:caption]
    options = {
      :name => name,
      :description => description,
      :script => script
    }.update(options)
    preparation = options.delete(:preparation)
    result = __with_redirection__(options) do
      Tengine::Job::Template::Jobnet.new(options)
    end
    @jobnet.children << result
    if preparation
      Tengine::Job::Dsl::Loader.loading_template_block_store[result] = [:preparation, preparation]
    end
    result
  end

  def hadoop_job_run(name, *args, &block)
    script, description, options = __parse_job_args__(name, args)
    options[:script] = script
    options[:jobnet_type_key] = :hadoop_job_run
    jobnet(name, description, options, &block)
  end

  def hadoop_job(name, options = {})
    result = __with_redirection__(options) do
      Tengine::Job::Template::Jobnet.new(:name => name, :jobnet_type_key => :hadoop_job)
    end
    result.children << start  = Tengine::Job::Template::Start.new
    result.children << fork   = Tengine::Job::Template::Fork.new
    result.children << map    = Tengine::Job::Template::Jobnet.new(:name => "Map"   , :jobnet_type_key => :map_phase   )
    result.children << reduce = Tengine::Job::Template::Jobnet.new(:name => "Reduce", :jobnet_type_key => :reduce_phase)
    result.children << join   = Tengine::Job::Template::Join.new
    result.children << _end   = Tengine::Job::Template::End.new
    result.edges.new(:origin_id => start.id , :destination_id => fork.id  )
    result.edges.new(:origin_id => fork.id  , :destination_id => map.id   )
    result.edges.new(:origin_id => fork.id  , :destination_id => reduce.id)
    result.edges.new(:origin_id => map.id   , :destination_id => join.id  )
    result.edges.new(:origin_id => reduce.id, :destination_id => join.id  )
    result.edges.new(:origin_id => join.id  , :destination_id => _end.id  )
    @jobnet.children << result
    result
  end

  def finally(&block)
    jobnet("finally", :jobnet_type_key => :finally, &block)
  end

  def expansion(root_jobnet_name, options = {})
    options = {
      :name => root_jobnet_name,
    }.update(options)
    result = __with_redirection__(options) do
      Tengine::Job::Template::Expansion.new(options)
    end
    @jobnet.children << result
    result
  end

  private
  def __parse_job_args__(name, args)
    options = args.extract_options!
    description_or_script, script = *args
    if script
      description = description_or_script
    else
      script = description_or_script
      description = name
    end
    return script, description, options
  end

  def __with_redirection__(options)
    destination_names = Array(options.delete(:to) || options.delete(:redirect_to))
    result = yield
    destination_names.each do |dest_name|
      @redirections << [result.name, dest_name]
    end
    result
  end

end
