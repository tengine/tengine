# -*- coding: utf-8 -*-
require 'tengine_event'

# NullLoggerはロガーのNull Objectです。
# Loggerと同じインタフェースを持ちますが何も動作しません。
class Tengine::NullLogger
  %w[debug info warn error fatal log].each do |log_level|
    class_eval("def #{log_level}(*args); end")
  end
end
