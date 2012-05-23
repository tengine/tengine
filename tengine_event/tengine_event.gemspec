# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name = "tengine_event"
  s.version = version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm"]
  # s.date = "2012-05-23"
  s.description = "Tengine Event API to access the queue"
  s.email = "tengine-info@groovenauts.jp"
  s.executables = ["tengine_fire", "tengine_event_sucks"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = Dir["Gemfile", "Gemfile.lock", "README.rdoc", "bin/**/*", "lib/**/*"]

  s.homepage = "https://github.com/tengine/tengine/tree/develop/tengine_event"
  s.licenses = ["MPL2.0/LGPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary = "Tengine Event API to access the queue"

  s.add_runtime_dependency('activesupport', ">= 3.0.0")
  s.add_runtime_dependency('tengine_support', "~> #{version}")
  s.add_runtime_dependency('uuid', "~> 2.3.4")
  s.add_runtime_dependency('amqp', "~> 0.8.0")
  s.add_development_dependency('rspec', "~> 2.6.0")
  s.add_development_dependency('yard', "~> 0.7.2")
  s.add_development_dependency('bundler', "~> 1.1.3")
  s.add_development_dependency('jeweler', "~> 1.6.4")
  s.add_development_dependency('simplecov', "~> 0.5.3")
  s.add_development_dependency('ZenTest', "~> 4.6.2")
  s.add_development_dependency('ci_reporter', "~> 1.6.5")
end

