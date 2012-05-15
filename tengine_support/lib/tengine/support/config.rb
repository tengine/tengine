require 'tengine/support'

module Tengine::Support::Config
  autoload :Definition, 'tengine/support/config/definition'

  autoload :Mongoid, 'tengine/support/config/mongoid'
  autoload :Amqp   , 'tengine/support/config/amqp'
  autoload :Logger , 'tengine/support/config/logger'

  class << self
    def suite(options = {}, &block)
      result = Tengine::Support::Config::Definition::Suite.new
      result.instance_eval(&block)
      result
    end
  end
end
