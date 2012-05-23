# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name = "tengine_resource"
  s.version = version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm", "hiroshinakao"]
  # s.date = "2012-05-02"
  s.description = "tengine_resource provides physical/virtual server management"
  s.email = "tengine-info@groovenauts.jp"
  s.executables = ["tengine_resource_watchd"]
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

  s.add_runtime_dependency('tengine_support', "~> #{version}")
  s.add_runtime_dependency('tengine_core', "~> #{version}")
  s.add_runtime_dependency('wakame-adapters-tengine', "~> 0.0.0")
  s.add_runtime_dependency('right_aws', "~> 2.1.0")
  s.add_runtime_dependency('net-ssh', "~> 2.2.1")
  s.add_development_dependency('rspec', "~> 2.6.0")
  s.add_development_dependency('factory_girl', "~> 2.1.2")
  s.add_development_dependency('yard', "~> 0.7.2")
  s.add_development_dependency('bundler', "~> 1.1.3")
  s.add_development_dependency('jeweler', "~> 1.6.4")
  s.add_development_dependency('simplecov', "~> 0.5.3")
  s.add_development_dependency('ZenTest', "~> 4.6.2")
end
