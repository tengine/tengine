# -*- coding: utf-8 -*-
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
  autoload :DslEnv,       'tengine/core/dsl_env'
  # autoload :DslFilterDef, 'tengine/core/dsl_filter_def'

  autoload :IoToLogger,   'tengine/core/io_to_logger'

  # 設定ファイルエラー
  class ConfigError < StandardError
  end

end
