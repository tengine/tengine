# -*- coding: utf-8 -*-
require 'tengine/job/structure'

# # Tengine Jobnet Element Selector Notation
# Tengineジョブネット要素セレクタ記法
#
# Tengineジョブネット要素セレクタ記法は、TenigneのジョブDSLで生成されるジョブネットから
# 特定のVertexやEdgeを特定するための記述方法です。
# 正式名称が長いので、ここでは略して「セレクタ記法」と呼ぶ
#
# ## 背景
# Tengienジョブでは、ジョブやジョブネットなどのvertexとそれらを結ぶedgeが連携して動くこと
# ジョブの実行を行うが、ジョブ、ジョブネット以外のvertexとedgeには名前がついていない。
# しかし、ジョブネット内の要素群が連携して動作することを確認するためには、どのvertex、
# あるいはどのedgeなのかという点について状態などを確認する必要がある。
#
# ## name_path
# Tengineのジョブ／ジョブネットは親子関係によるツリー構造を持ち、
# それぞれ兄弟間では重複しない名前が指定されるので、スラッシュによって区切ることによって
# ファイルパスのような表記によって、どのジョブ／ジョブネットなのかを特定できる
#
# ## name_pathの問題点
# ジョブとジョブネットについては名前があるのでname_pathだけで特定できるが、
# それ以外のedgeやfork, joinについては特定することができない。
#
# ## それぞれの指定方法
# ### ジョブ／ジョブネット
# 1. name_pathをそのまま
#  * 例: "/j100/j110/j111"    # jxxx は、ジョブあるいはジョブネットを想定しています
# 2. "#{ジョブ／ジョブネット名}@#{ジョブネットのname_path}"
#  * 例: "j111@/j100/j110"
#
#
# ### startとend
# 1. "#{start or end}!#{ジョブネットのセレクタ}"
#  * 例: start!j110@/j100
#  * 例: end!/j100/j110
# 2. "#{start or end}!#{ジョブネットのname_path}"
#  * 例: start@/j100/j110
#  * 例: end@/j100/j110
#
# ### edge
# #### ジョブ／ジョブネットの前後のedge
# 1. "#{prev or next}!#{ジョブ／ジョブネットのセレクタ}"
#  * 例: prev!j110@/j100
#  * 例: next!/j100/j110
#
# #### ジョブ／ジョブネットの間のedge
# 1. "#{前のジョブ名}~#{後のジョブ名}@#{ジョブネットのセレクタ}"
#  * 例: j111~j112@/j100/j110
#
# #### fork-join間のedge
# 1. "fork~join!#{前のジョブ名}~#{後のジョブ名}@#{ジョブネットのセレクタ}"
#  * 例: fork~join!j112~j113@/j100/j110
#
# ### fork, join
# 1. "#{fork or join}!#{前のジョブ名}~#{後のジョブ名}@#{ジョブネットのセレクタ}"
#  * 例: fork!j112~j113@/j100/j110
#  * 例: join!j112~j113@/j100/j110
#
#

module Tengine::Job::Structure::ElementSelectorNotation

  class NotFound < Tengine::Errors::NotFound
    attr_reader :jobnet, :notation
    def initialize(jobnet, notation)
      @jobnet, @notation = jobnet, notation
    end

    def message
      "Tengine Jobnet Element not found by selector #{notation.inspect} in #{@jobnet.name_path}"
    end
  end

  def base_module
    self.template? ? Tengine::Job::Template : Tengine::Job::Runtime
  end

  NAME_PART = /[A-Za-z_][\w\-]*/.freeze
  NAME_PATH_PART = /[A-Za-z_\/][\w\-\/]*/.freeze

  # elementメソッドは指定されたnotationによって対象となる要素が見つからなかった場合はnilを返します。
  # 例外をraiseさせたい場合は element!メソッドを使ってください。
  def element(notation)
    direction, current_path = *notation.split(/@/, 2)
    return vertex_by_name_path(direction) if current_path.nil? && Tengine::Job::Structure::NamePath.absolute?(direction)
    current = current_path ? vertex_by_name_path(current_path) : self
    raise "#{current_path.inspect} not found" unless current
    case direction
    # when /^prev!(?:#{Tengine::Core::Validation::BASE_NAME.format})/
    when /^(prev|next)!(#{NAME_PATH_PART})$/ then
      job = $2 ? current.vertex_by_name_path($2) : self
      job.send("#{$1}_edges").first
    when /^(start|end|finally)!(#{NAME_PATH_PART})$/ then
      job = $2 ? current.vertex_by_name_path($2) : self
      job.child_by_name($1)
    when /^(start|end|finally)$/ then
      current.child_by_name($1)
    when /^(#{NAME_PART})~(#{NAME_PART})$/ then
      job1 = current.child_by_name($1)
      job2 = current.child_by_name($2)
      job1.next_edges.detect{|edge| edge.destination_id == job2.id}
    when /^(fork|join)!(#{NAME_PART})~(#{NAME_PART})$/ then
      klass = base_module.const_get($1.capitalize)
      job1 = current.child_by_name($2)
      job2 = current.child_by_name($3)
      paths = PathFinder.new(self, job1, job2).process
      paths.each do |path|
        path.each do |element|
          return element if element.is_a?(klass)
        end
      end
    when /^fork~join!(#{NAME_PART})~(#{NAME_PART})$/ then
      job1 = current.child_by_name($1)
      job2 = current.child_by_name($2)
      paths = PathFinder.new(self, job1, job2).process
      paths.each do |path|
        path.each do |element|
          if element.is_a?(base_module.const_get(:Edge))
            if element.origin.is_a?(base_module.const_get(:Fork)) &&
                element.destination.is_a?(base_module.const_get(:Join))
              return element
            end
          end
        end
      end
    else
      current.child_by_name(direction)
    end
  end

  # element!メソッドは指定されたnotationによって対象となる要素が見つからなかった場合はnilを返します。
  # 例外をraiseさせたい場合は element!メソッドを使ってください。
  def element!(notation, *args)
    result = element(notation, *args)
    raise NotFound.new(self, notation) unless result
    result
  end

  class PathFinder
    def initialize(client, origin, dest)
      @client = client
      @origin, @dest = origin, dest
    end

    def process
      @routes = []
      @current_route = []
      @origin.accept_visitor(self)
      @routes.select{|route| route.last == @dest}
    end

    def visit(element)
      @current_route << element
      if element.is_a?(@client.base_module.const_get(:Edge))
        element.destination.accept_visitor(self)
      else
        @routes << @current_route.dup
        return if element == @dest
        element.next_edges.each do |edge|
          bak = @current_route.dup
          begin
            edge.accept_visitor(self)
          ensure
            @current_route = bak
          end
        end
      end
    end
  end

end
