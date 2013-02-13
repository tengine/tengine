# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

module Tengine::Job::Runtime::StateTransition

  def self.included(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    def available(method_name, options = {})
      original_method = :"__#{method_name}_without_ignore_and_na"
      available_phase_keys = Array(options[:on])
      ignored_phase_keys = Array(options[:ignored])
      ignore_case = ignored_phase_keys.empty? ? "" :
        "when #{ignored_phase_keys.map(&:inspect).join(', ')} then return"
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        if method_defined?(:#{original_method})
          raise "Already available_on #{method_name}"
        end
        alias #{original_method} #{method_name}

        def #{method_name}(*args, &block)
          case self.phase_key
          when #{available_phase_keys.map(&:inspect).join(', ')} then
            #{original_method}(*args, &block)
          #{ignore_case}
          else
            raise Tengine::Job::Executable::PhaseError, "\#{name_path} \#{self.class.name}##{method_name} not available when the phase_key of \#{self.name_path.inspect} is \#{self.phase_key.inspect}"
          end
        end
      EOS

    end
  end

end
