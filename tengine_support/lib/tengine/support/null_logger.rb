# -*- coding: utf-8 -*-
require 'tengine/support'

# NullLoggerはロガーのNull Objectです。
# Loggerと同じインタフェースを持ちますが何も動作しません。
class Tengine::Support::NullLogger
  %w[debug info warn error fatal].each do |log_level|
    class_eval("def #{log_level}(*args); end")
  end
end
