require 'tengine_support'

module Tengine::Support
  autoload :YamlWithErb,  'tengine/support/yaml_with_erb'
  autoload :NullLogger,   'tengine/support/null_logger'
  autoload :Config,       'tengine/support/config'
  autoload :MongoIndex,   'tengine/support/mongo_index'
end
