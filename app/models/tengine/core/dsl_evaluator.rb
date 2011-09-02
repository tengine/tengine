# -*- coding: utf-8 -*-
module Tengine::Core::DslEvaluator
  attr_accessor :config

  def evaluate
    config.dsl_file_paths.each { |f| self.instance_eval(File.read(f), f) }
  end
end
