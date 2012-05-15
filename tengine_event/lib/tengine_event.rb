module Tengine
  autoload :Event     , 'tengine/event'
  autoload :Mq        , 'tengine/mq'
  autoload :NullLogger, 'tengine/null_logger'

  class << self
    def logger
      @logger ||= NullLogger.new # ::Logger.new(STDOUT)
    end
    attr_writer :logger
  end

end
