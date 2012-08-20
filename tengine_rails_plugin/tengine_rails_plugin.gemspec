$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tengine_rails_plugin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tengine_rails_plugin"
  s.version     = TengineRailsPlugin::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of TengineRailsPlugin."
  s.description = "TODO: Description of TengineRailsPlugin."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "tengine_event", "~> 0.4.0"

  s.add_development_dependency "sqlite3"
end
