# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require "capybara/rspec"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Tengine::Core::MethodTraceable.disabled = true
require 'logger'
log_path = File.expand_path("../log/test.log", File.dirname(__FILE__))
Tengine.logger = Logger.new(log_path)
Tengine.logger.level = Logger::DEBUG
Tengine::Core.stdout_logger = Logger.new(log_path)
Tengine::Core.stdout_logger.level = Logger::DEBUG
Tengine::Core.stderr_logger = Logger.new(log_path)
Tengine::Core.stderr_logger.level = Logger::DEBUG

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  config.before(:all) do
    unless Tengine::Core::Setting.first(:conditions => {:name => "dsl_version"})
      Tengine::Core::Setting.create!(:name => "dsl_version", :value => "1234567890")
    end
  end

end
