# -*- coding: utf-8 -*-
require 'tengine/job/structure'

require 'tsort'

class Tengine::Job::Structure::EdgeBuilder
  include TSort

  def initialize(client, boot_job_names, redirections, options = {})
    @client, @boot_job_names, @redirections = client, boot_job_names, redirections.dup
    @graph = Hash.new do |h, k| h[k] = Array.new end
    @redirections.each do |(x, y)|
      @graph[x] << y
    end
    @fork_class = options[:fork_class]
    @join_class = options[:join_class]
  end

  def children; @client.children; end
  def child_by_name(*args); @client.child_by_name(*args); end
  def new_edge(*args); @client.new_edge(*args); end
  def prepare_end(*args, &block); @client.prepare_end(*args, &block); end

  def process
    tsort
  rescue TSort::Cyclic
    raise Tengine::Job::Structure::Error, "circular dependency found in jobnet ``#{@client.name}''"
  else
    build_start_edges
    build_edge_by_redirections
    prepare_end do |_end|
      build_end_edges(_end, @boot_job_names.map{|jn| [:start, jn]} + @redirections)
    end
  end

  private

  def tsort_each_child node, &block
    @graph.fetch(node, Array.new).each(&block)
  end

  def tsort_each_node(&block)
    @graph.each_key(&block)
  end

  def build_start_edges
    start = children.first
    case @boot_job_names.length
    when 0 then raise "Must be a bug!!!"
    when 1 then
      new_edge(start, child_by_name(@boot_job_names.first))
    else
      fork = @fork_class.new
      children << fork
      new_edge(start, fork)
      @boot_job_names.each do |boot_job_name|
        new_edge(fork, child_by_name(boot_job_name))
      end
    end
  end

  def build_edge_by_redirections
    prepare_to_build_edge_by_redirections # 処理の準備
    build_forks_and_edges      # Forkを生成して特異edge以外を繋ぐ
    build_joins_and_edges      # Joinを生成して特異edge以外を繋ぐ
    build_fork_to_join_edges   # 特異edgeの両端になるforkとjoinは生成されているのでそれらを繋ぐ
    build_normal_edges         # Fork、Join、特異edgeなどに関係しなかった普通のedgeを繋ぐ
  end

  def prepare_to_build_edge_by_redirections
    # 各vertexがstartあるいはendとしてそれぞれ何回使われているのかを集計
    start_vertex_counts = @redirections.inject({}){|d, (_start, _)| d[_start] ||= 0; d[_start] += 1; d}
    end_vertex_counts   = @redirections.inject({}){|d, (_, _end)| d[_end  ] ||= 0; d[_end  ] += 1; d}
    # ２回以上startに使われているやつはforkの元、２回以上endに使われているやつはjoinの先になる
    @fork_origins = start_vertex_counts.delete_if{|_,v| v < 2}.keys
    @join_destinations = end_vertex_counts.delete_if{|_,v| v < 2}.keys
    # ForkからJoinへedgeで結ばれる箇所を「特異edge」と呼び、特別扱いする
    @fork_to_join = []
    @redirections.each do |(_start, _end)|
      if @fork_origins.include?(_start) && @join_destinations.include?(_end)
        @fork_to_join << [_start, _end]
      end
    end
    # puts "=" * 100
    # puts "fork origins     : " << @fork_origins.inspect
    # puts "join_destinations: " << @join_destinations.inspect
    # puts "fork_to_join     : " << @fork_to_join.inspect
    @no_edge_redirections = @redirections.dup
  end

  def build_forks_and_edges
    @fork_origin_to_fork = {}
    @fork_origins.each do |fork_origin|
      children << fork = @fork_class.new
      @fork_origin_to_fork[fork_origin] = fork
      new_edge(child_by_name(fork_origin), fork)
      @redirections.dup.
        delete_if{|r| @fork_to_join.include?(r)}.
        select{|(_start,_)| _start == fork_origin}.
        each{|(_, _end)| new_edge(fork, child_by_name(_end))}
      @no_edge_redirections.delete_if{|_start, _| _start == fork_origin}
    end
  end

  def build_joins_and_edges
    @join_destination_to_join = {}
    @join_destinations.each do |join_destination|
      children << join = @join_class.new
      @join_destination_to_join[join_destination] = join
      @redirections.dup.
        delete_if{|r| @fork_to_join.include?(r)}.
        select{|(_, _end)| _end == join_destination}.
        each{|(_start, _)| new_edge(child_by_name(_start), join)}
      new_edge(join, child_by_name(join_destination))
      @no_edge_redirections.delete_if{|_, _end| _end == join_destination}
    end
  end

  def build_fork_to_join_edges
    @fork_to_join.each do |fork_origin, join_destination|
      new_edge(
        @fork_origin_to_fork[fork_origin],
        @join_destination_to_join[join_destination])
    end
  end

  def build_normal_edges
    @no_edge_redirections.each do |(_start, _end)|
      new_edge(child_by_name(_start), child_by_name(_end))
    end
  end

  def build_end_edges(_end, redirections)
    end_points = select_end_points(redirections)
    case end_points.length
    when 0 then raise "Must be a bug!!!"
    when 1 then new_edge(child_by_name(end_points.first), _end)
    else
      join = @join_class.new
      children << join
      end_points.each{|point| new_edge(child_by_name(point), join)}
      new_edge(join, _end)
    end
  end

  def select_end_points(redirections)
    vertexes = redirections.flatten.uniq
    redirections.each do |(_start, _end)|
      vertexes.delete(_start)
    end
    vertexes
  end

end
