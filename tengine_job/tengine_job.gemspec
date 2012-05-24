# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name = "tengine_job"
  s.version = version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm", "guemon"]
  # s.date = "2012-05-21"
  s.description = "tengine_job provides jobnet management"
  s.email = "tengine-info@groovenauts.jp"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = Dir["Gemfile", "Gemfile.lock", "README.rdoc", "examples/**/*", "lib/**/*" ]

  s.homepage = "http://github.com/tengine/tengine_job"
  s.licenses = ["MPL2.0/LGPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "tengine_job provides jobnet management"

  s.add_runtime_dependency('tengine_support', "~> #{version}")
  s.add_runtime_dependency('tengine_core', "~> #{version}")
  s.add_runtime_dependency('tengine_resource', "~> #{version}")
  s.add_development_dependency('rake', "~> 0.9.2.2")
  s.add_development_dependency('rspec', "~> 2.6.0")
  s.add_development_dependency('factory_girl', "~> 2.1.2")
  s.add_development_dependency('yard', "~> 0.7.2")
  s.add_development_dependency('bundler', "~> 1.1.3")
  s.add_development_dependency('simplecov', "~> 0.5.3")
  s.add_development_dependency('ZenTest', "~> 4.6.2")
end
