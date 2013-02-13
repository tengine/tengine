# -*- coding: utf-8 -*-
require 'tengine/job'

# ジョブDSLをロードする際に使用される語彙に関するメソッドを定義するモジュール
module Tengine::Job::DslBinder
  include Tengine::Job::DslEvaluator

  def jobnet(name, *args, &block)
    Tengine::Job::RootJobnetTemplate.by_name(name)
  end

end
