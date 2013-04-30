$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]
require 'rspec'
require 'tengine_job_agent'

gem_names = ["tengine_event"]
gem_names.each{|f| require f}

base_dirs = gem_names.map{|gem_name| Gem.loaded_specs[gem_name].gem_dir}
base_dirs += [File.expand_path(".")]
base_dirs.each do |dir_path|
  Dir["#{dir_path}/spec/support/**/*.rb"].each {|f| require f}
end

RSpec.configure do |config|
  unless ENV['MANUAL'] == 'true'
    config.filter_run_excluding manual: true
  end

  if ENV['TRAVIS'] == 'true'
    config.filter_run_excluding skip_travis: true
  end
end
