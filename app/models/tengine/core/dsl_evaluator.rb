# -*- coding: utf-8 -*-
module Tengine::Core::DslEvaluator
  attr_accessor :config

  def evaluate
    setup_core_ext
    begin
      Tengine::Core.stdout_logger.debug("dsl_file_paths:\n  " << config.dsl_file_paths.join("\n  "))
      config.dsl_file_paths.each { |f| self.instance_eval(File.read(f), f) }
    ensure
      teardown_core_ext
    end
  end

  def setup_core_ext
    Symbol.class_eval do
      def and(other)
        Tengine::Core::DslFilterDef.new(
          [self.to_s, other.to_s],
          {
            'method' => :and,
            'children' => [
              { 'pattern' => self, 'method' => :find_or_mark_in_session },
              { 'pattern' => other, 'method' => :find_or_mark_in_session },
            ]
          })
      end
      alias_method :&, :and
    end

  end

  def teardown_core_ext
    Symbol.class_eval do
      remove_method(:&, :and)
    end
  end
end
