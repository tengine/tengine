require 'tengine_support'

module Tengine
  autoload :Event     , 'tengine/event'
  autoload :Mq        , 'tengine/mq'

  class << self
    def logger
      @logger ||= ::Tengine::Support::NullLogger.new # ::Logger.new(STDOUT)
    end
    attr_writer :logger
  end

end
