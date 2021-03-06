$:.push File.expand_path("../lib", __FILE__)

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip

require File.expand_path("../../dependencies", __FILE__)

# Maintain your gem's version:
require "tengine_rails_plugin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tengine_rails_plugin"
  s.version     = version
	s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm"]
  s.email = "tengine-info@groovenauts.jp"
  s.homepage    = "https://github.com/tengine/tengine/tree/develop/tengine_rails_plugin"
  s.licenses = ["MPL2.0/LGPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary     = "tengine_rails_plugin supports the use of tengine in Rails application."
  s.description = "tengine_rails_plugin supports the use of tengine in Rails application."

  s.files = Dir["lib/**/*", "Gemfile", "Gemfile.lock", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "tengine_event", "~> #{version}"
  s.add_dependency "tengine_support", "~> #{version}"

  common_development_dependencies(s)
  s.add_development_dependency "sqlite3"
end
