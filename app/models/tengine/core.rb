# -*- coding: utf-8 -*-
require 'tengine' # 本来はtengine_coreであるべき
require 'logger'

module Tengine::Core
  autoload :Bootstrap,    'tengine/core/bootstrap'
  autoload :Config,       'tengine/core/config'
  autoload :Kernel,       'tengine/core/kernel'
  # autoload :Driver,       'tengine/core/driver'
  # autoload :Handler,      'tengine/core/handler'
  # autoload :HandlerPath,  'tengine/core/handler_path'
  # autoload :Filter,       'tengine/core/filter'
  autoload :DslLoader,    'tengine/core/dsl_loader'
  autoload :DslBinder,    'tengine/core/dsl_binder'
  autoload :DslContext,       'tengine/core/dsl_context'
  # autoload :DslFilterDef, 'tengine/core/dsl_filter_def'

  autoload :IoToLogger,   'tengine/core/io_to_logger'
  autoload :MethodTraceable, 'tengine/core/method_traceable'

  # developmentで動かすと
  #   ActionController::RoutingError (uninitialized constant Tengine::DslError)
  # が発生してしまうため StandardError から継承するように変更しました
  class DslError < StandardError # ::Tengine::DslError
  end

  class << self
    # Tengine::Coreの正常時の動きをアプリケーション運用者が確認できる内容を出力するロガー
    # ログレベルがinfoでも出力する内容は少ない
    def stdout_logger
      @stdout_logger ||= Logger.new(STDOUT)
    end
    attr_writer :stdout_logger

    # Tengine::Coreの異常発生時の動きをアプリケーション運用者が確認できる内容を出力するロガー
    def stderr_logger
      @stderr_logger ||= Logger.new(STDERR)
    end
    attr_writer :stderr_logger
  end

  # 設定ファイルエラー
  class ConfigError < StandardError
  end

end
