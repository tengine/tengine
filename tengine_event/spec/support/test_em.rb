# -*- coding: utf-8 -*-
require 'timeout'

require 'eventmachine'

module EventMachine

  DEFAULT_TIMEOUT = 10 # seconds

  class << self

    # call run with timeout
    # @option options  [Numeric] :timeout  timeout for EventMachine running.
    #
    # other arguments and block are passed to run method.
    def run_test(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      t = (options[:timeout] || ENV['DEFAULT_TIMEOUT'] || DEFAULT_TIMEOUT).to_i
      timeout(t) do
        return run(*args, &block)
      end
    end
  end

end
