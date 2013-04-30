# -*- coding: utf-8 -*-
require 'tengine/job'

module Tengine::Job::Dsl
  autoload :Binder              , 'tengine/job/dsl/binder'
  autoload :Evaluator           , 'tengine/job/dsl/evaluator'
  autoload :Loader              , 'tengine/job/dsl/loader'

  # DSLの記述に問題があることを示す例外
  class Error < ::Tengine::DslError
  end

end
