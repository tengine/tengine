# -*- coding: utf-8 -*-
require 'tengine_job'

require 'active_support/concern'

module Tengine::Job
  autoload :DslEvaluator        , "tengine/job/dsl_evaluator"
  autoload :DslLoader           , "tengine/job/dsl_loader"
  autoload :DslBinder           , "tengine/job/dsl_binder"

  autoload :Signal              , 'tengine/job/signal'

  autoload :Execution           , "tengine/job/execution"

  autoload :Category            , "tengine/job/category"
  autoload :Edge                , "tengine/job/edge"
  autoload :Vertex              , "tengine/job/vertex"

  autoload :Start               , "tengine/job/start"
  autoload :End                 , "tengine/job/end"
  autoload :Junction            , "tengine/job/junction"
  autoload :Fork                , "tengine/job/fork"
  autoload :Join                , "tengine/job/join"

  autoload :Job                 , "tengine/job/job"

  autoload :Jobnet              , "tengine/job/jobnet"
  autoload :JobnetActual        , "tengine/job/jobnet_actual"
  autoload :RootJobnetActual    , "tengine/job/root_jobnet_actual"
  autoload :JobnetTemplate      , "tengine/job/jobnet_template"
  autoload :RootJobnetTemplate  , "tengine/job/root_jobnet_template"

  autoload :Expansion           , "tengine/job/expansion"

  autoload :Root                , "tengine/job/root"
  autoload :NamePath            , "tengine/job/name_path"
  autoload :Executable          , "tengine/job/executable"
  autoload :Stoppable           , "tengine/job/stoppable"
  autoload :Killing             , "tengine/job/killing"
  autoload :Connectable         , "tengine/job/connectable"
  autoload :ScriptExecutable    , "tengine/job/script_executable"

  autoload :MmCompatibility     , "tengine/job/mm_compatibility"
  autoload :ElementSelectorNotation, "tengine/job/element_selector_notation"

  class << self
    # tengine_coreからそのプラグインへ通知を受けるための
    def notify(sender, msg)
Tengine::Core.stdout_logger.info("*" * 100)
        Dir[File.expand_path("job/drivers/*.rb", File.dirname(__FILE__))].each do |f|
Tengine::Core.stdout_logger.info("#{self.name}.notify  #{f}")
        end
      # if (msg == :before___evaluate__) # だと、最初にtengine/jobがrequireされる前に実行されるのでフックできません
      if (msg == :after___evaluate__)
        Tengine::Core::Driveable.module_eval{ include Tengine::Job::DslBinder }
        Dir[File.expand_path("job/drivers/*.rb", File.dirname(__FILE__))].each do |f|
          # Tengine::Core.stdout_logger.debug("#{self.name} now evaluating #{f}")
          # sender.instance_eval(File.read(f), f)
          load(f)
        end
      end
      if (msg == :after_load_dsl) && sender.respond_to?(:config)
        # RootJobnetTemplateのdsl_filepathからCategoryを生成します
        Tengine::Job::Category.update_for(sender.config.dsl_dir_path)
      end
    end


    # 自動テストで呼び出しをフックするためのメソッド
    def test_harness(idx, msg)
    end

    # test_harnessメソッドに渡されるidxを初期化します
    def test_harness_clear
      @test_harness_index = 0
      Tengine.logger.debug("#{self.name}.test_harness_clear")
    end

    # test_harness呼び出すメソッド。
    # ライブラリを提供する側が使用します。
    def test_harness_hook(msg)
      @test_harness_index ||= 0
      @test_harness_index += 1
      Tengine.logger.debug("#{self.name}.test_harness(#{@test_harness_index}, #{msg.inspect})")
      test_harness(@test_harness_index, msg)
    end

  end

  # DSLの記述に問題があることを示す例外
  class DslError < ::Tengine::DslError
  end

end
