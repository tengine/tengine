# -*- coding: utf-8 -*-
module Tengine::Job::DslLoader
  include Tengine::Job::DslEvaluator

  def jobnet(name, *args, &block)
    options = args.extract_options!
    options = {
      :name => name,
      :description => args.first || name,
    }.update(options)
    auto_sequence = options.delete(:auto_sequence)
    result = Tengine::Job::JobnetTemplate.new(options)
    result.children << Tengine::Job::Start.new
    @jobnet.children << result if @jobnet
    __stack_instance_variable__(:@auto_sequence,  auto_sequence || @auto_sequence) do
      __stack_instance_variable__(:@jobnet, result, &block)
      __build_edges__(result)
    end
    result.save!
    result
  end

  def auto_sequence
    @auto_sequence = true
  end

  def job(name, *args)
    script, description, options = __parse_job_args__(name, args)
    options = {
      :name => name,
      :description => description,
      :script => script
    }.update(options)
    @jobnet.children << result = Tengine::Job::ScriptTemplate.new(options)
    result
  end

  def hadoop_job_run(name, *args, &block)
    script, description, options = __parse_job_args__(name, args)
    options[:script] = script
    jobnet(name, description, options, &block)
  end

  def hadoop_job(name)
    result = Tengine::Job::JobnetTemplate.new(:name => name)
    result.children << start  = Tengine::Job::Start.new
    result.children << fork   = Tengine::Job::Fork.new
    result.children << map    = Tengine::Job::Job.new(:name => "Map")
    result.children << reduce = Tengine::Job::Job.new(:name => "Reduce")
    result.children << join   = Tengine::Job::Join.new
    result.children << _end   = Tengine::Job::End.new
    result.edges.new(:origin_id => start.id , :destination_id => fork.id  )
    result.edges.new(:origin_id => fork.id  , :destination_id => map.id   )
    result.edges.new(:origin_id => fork.id  , :destination_id => reduce.id)
    result.edges.new(:origin_id => map.id   , :destination_id => join.id  )
    result.edges.new(:origin_id => reduce.id, :destination_id => join.id  )
    result.edges.new(:origin_id => join.id  , :destination_id => _end.id  )
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

  def __build_edges__(target, auto_sequence = @auto_sequence)
    if target.children.length == 1 # 最初に追加したStartだけなら。
      target.children.delete_all
      return
    end
    target.prepare_start_and_end
    target.build_sequencial_edges if auto_sequence
  end

end
