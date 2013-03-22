$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'tengine_event'
require 'timeout'

require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  unless ENV['MANUAL'] == 'true'
    config.filter_run_excluding manual: true
  end

  if ENV['TRAVIS'] == 'true'
    config.filter_run_excluding skip_travis: true
  end

  if ENV['TEST_RABBITMQ_DISABLED'] =~ /^true$|^on$/i
    config.filter_run_excluding test_rabbitmq_required: true
  end
end
