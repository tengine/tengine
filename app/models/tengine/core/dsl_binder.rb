# -*- coding: utf-8 -*-
module Tengine::Core::DslBinder
  def evaluate
    $:.unshift @config[:dsl_store_path]
  end
end
