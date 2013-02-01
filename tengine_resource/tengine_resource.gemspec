# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip
require File.expand_path("../../dependencies", __FILE__)

Gem::Specification.new do |s|
  s.name = "tengine_resource"
  s.version = version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm", "hiroshinakao"]
  # s.date = "2012-05-02"
  s.description = "tengine_resource provides physical/virtual server management"
  s.email = "tengine-info@groovenauts.jp"
  s.executables = ["tengine_resource_watchd", "create_indexes_for_tengine_resource"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = Dir[ "Gemfile", "Gemfile.lock", "README.rdoc",
    "bin/**/*", "config/**/*", "lib/**/*", "spec/fixtures/**/*",
    "tmp/.gitkeep", # tengine_jobのspecが必要としています
  ]
  s.homepage = "http://github.com/tengine/tengine_resource"
  s.licenses = ["MPL2.0/LGPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary = "tengine_resource provides physical/virtual server management"

  s.add_runtime_dependency('thor', "~> 0.17.0")
  s.add_runtime_dependency('text-table', "~> 1.2.2")

  s.add_runtime_dependency('tengine_support', "~> #{version}")
  s.add_runtime_dependency('tengine_core', "~> #{version}")
  s.add_runtime_dependency('net-ssh', "~> 2.5.2")

  common_development_dependencies(s)
end
