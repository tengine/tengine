# -*- coding: utf-8 -*-
ENV["RACK_ENV"] ||= "test" # Mongoid.load!で参照しています

require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'factory_girl'

require 'tengine_job'
require 'mongoid'
Mongoid.load!(File.expand_path('mongoid.yml', File.dirname(__FILE__)))
Mongoid.default_session.drop


gem_names = ["tengine_core", "tengine_resource", "tengine_resource_ec2"]
gem_names.each{|f| require f}

base_dirs = gem_names.map{|gem_name| Gem.loaded_specs[gem_name].gem_dir}
# base_dirs += [File.expand_path("..", File.dirname(__FILE__))]
base_dirs += [File.expand_path(".")]
base_dirs.each do |dir_path|
  # fixtures/以下のファイルがsupport以下のファイルに依存していることがあるので、
  # あえて２回検索しています
  Dir["#{dir_path}/spec/support/**/*.rb"].each {|f| require f}
  Dir["#{dir_path}/spec/fixtures/**/*.rb"].each {|f| require f}
end


Tengine::Core::MethodTraceable.disabled = true
require 'logger'
log_path = File.expand_path("../tmp/log/test.log", File.dirname(__FILE__))
Tengine.logger = Logger.new(log_path)
Tengine.logger.level = Logger::DEBUG
Tengine::Core.stdout_logger = Tengine.logger
Tengine::Core.stderr_logger = Tengine.logger
# Tengine::Core.stdout_logger = Logger.new(log_path)
# Tengine::Core.stdout_logger.level = Logger::DEBUG
# Tengine::Core.stderr_logger = Logger.new(log_path)
# Tengine::Core.stderr_logger.level = Logger::DEBUG

Tengine::Core::Kernel.event_exception_reporter = :raise_all

Tengine::Core::Config::Core::Tengined.default_cache_drivers = true

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:all) do
    unless Tengine::Core::Setting.where({:name => "dsl_version"}).first
      Tengine::Core::Setting.create!(:name => "dsl_version", :value => "1234567890")
    end
  end

end

Dir["#{File.expand_path('factories', File.dirname(__FILE__))}/**/*.rb"].each {|f| require f}
