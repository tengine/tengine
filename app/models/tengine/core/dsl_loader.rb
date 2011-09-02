# -*- coding: utf-8 -*-
module Tengine::Core::DslLoader
  def evaluate
    $:.unshift @config[:dsl_store_path]
    load @config[:dsl_file] if @config[:dsl_file]
  end
end
