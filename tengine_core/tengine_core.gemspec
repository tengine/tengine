# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name = "tengine_core"
  s.version = version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm", "hiroshinakao"]
  # s.date = "2012-05-02"
  s.description = "tengine_core is a framework/engine to support distributed processing"
  s.email = "tengine-info@groovenauts.jp"
  s.executables = ["tengined", "tengine_heartbeat_watchd", "tengine_atd"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = Dir["Gemfile", "Gemfile.lock", "README.md", "examples/**/*", "examples2/**/*",
    "bin/**/*", "failure_examples/**/*", "lib/**/*" ]

  s.homepage = "https://github.com/tengine/tengine/tree/develop/tengine_core"
  s.licenses = ["MPL2.0/LGPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary = "tengine_core is a framework/engine to support distributed processing"

  s.add_runtime_dependency('activesupport', "~> 3.1.0")
  s.add_runtime_dependency('activemodel', "~> 3.1.0")
  s.add_runtime_dependency('selectable_attr', "~> 0.3.15")
  s.add_runtime_dependency('bson', "~> 1.5.2")
  s.add_runtime_dependency('bson_ext', "~> 1.5.2")
  s.add_runtime_dependency('mongo', "~> 1.5.2")
  s.add_runtime_dependency('mongoid', "~> 2.3.3")
  s.add_runtime_dependency('tengine_support', "~> #{version}")
  s.add_runtime_dependency('tengine_event', "~> #{version}")
  s.add_runtime_dependency('daemons', "~> 1.1.4")
  s.add_development_dependency('rspec', "~> 2.6.0")
  s.add_development_dependency('factory_girl', "~> 2.1.2")
  s.add_development_dependency('yard', "~> 0.7.2")
  s.add_development_dependency('bundler', "~> 1.1.3")
  s.add_development_dependency('jeweler', "~> 1.6.4")
  s.add_development_dependency('simplecov', "~> 0.5.3")
  s.add_development_dependency('ZenTest', "~> 4.6.2")
  s.add_development_dependency('rdiscount', ">= 0")
  s.add_development_dependency('kramdown',  ">= 0")
end

