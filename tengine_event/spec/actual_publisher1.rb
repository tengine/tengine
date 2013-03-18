#!/usr/bin/env ruby
# encoding: utf-8

require 'logger'
require'eventmachine'

__DIR__ = File.dirname(__FILE__)
base_dir = File.expand_path('../', __DIR__)
$LOAD_PATH << File.expand_path('lib', base_dir)
require 'tengine/event'

logger = Logger.new(File.expand_path("tmp/log/actual_publisher1.log", base_dir))
Tengine.logger = logger

sender = Tengine::Event::Sender.new(logger: logger)

logger.debug("#{__FILE__}##{__LINE__}")
EM.run do
  logger.debug("#{__FILE__}##{__LINE__}")
  sender.fire("foo") do
    logger.debug("#{__FILE__}##{__LINE__}")
    sender.fire("bar") do
      logger.debug("#{__FILE__}##{__LINE__}")
      sender.fire("baz")
      logger.debug("#{__FILE__}##{__LINE__}")
    end
    logger.debug("#{__FILE__}##{__LINE__}")
    sender.stop
    logger.debug("#{__FILE__}##{__LINE__}")
  end
  logger.debug("#{__FILE__}##{__LINE__}")
end
logger.debug("#{__FILE__}##{__LINE__}")
