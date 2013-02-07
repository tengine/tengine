# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip
require File.expand_path("../../dependencies", __FILE__)

Gem::Specification.new do |s|
  s.name = "tengine_core"
  s.version = version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm", "hiroshinakao"]
  # s.date = "2012-05-02"
  s.description = "tengine_core is a framework/engine to support distributed processing"
  s.email = "tengine-info@groovenauts.jp"
  s.executables = ["tengined", "tengine_heartbeat_watchd", "tengine_atd", "create_indexes_for_tengine_core"]
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

  s.add_runtime_dependency('activesupport', ">= 3.1.0")
  s.add_runtime_dependency('activemodel', ">= 3.1.0")
  s.add_runtime_dependency('selectable_attr', "~> 0.3.15")
  s.add_runtime_dependency('mongoid', "~> 3.0.0", "< 3.0.20")
  s.add_runtime_dependency('tengine_support', "~> #{version}")
  s.add_runtime_dependency('tengine_event', "~> #{version}")
  s.add_runtime_dependency('daemons', "~> 1.1.4")

  common_development_dependencies(s)
  s.add_development_dependency('factory_girl', "~> 3.3.0")
  s.add_development_dependency('kramdown',  ">= 0")
end
