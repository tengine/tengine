# -*- coding: utf-8 -*-
require 'tengine/job/dsl'

# ジョブDSLをロードする際に使用される語彙に関するメソッドを定義するモジュール
module Tengine::Job::Dsl::Binder
  include Tengine::Job::Dsl::Evaluator

  def jobnet(name, *args, &block)
    Tengine::Job::RootJobnetTemplate.by_name(name)
  end

end
