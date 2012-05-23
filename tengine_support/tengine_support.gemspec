# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.name = "tengine_support"
  s.version = version

  # s.platform    = Gem::Platform::RUBY # I wish tengine was able to work on JRuby too.
  # s.required_ruby_version = '>= 1.9.3'

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["shyouhei", "akm", "taigou"]
  s.date = "2012-05-02"
  s.description = "tengine_support provides utility classes/modules which is not included in active_support. It doesn't depend on other tengine gems."
  s.email = "tengine-info@groovenauts.jp"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = Dir["Gemfile", "README.md", "lib/**/*"]

  s.homepage = "http://github.com/tengine/tengine_support"
  s.licenses = ["MPL/LGPL"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary = "tengine_support provides utility classes/modules which isn't included in active_support."

  s.add_runtime_dependency('activesupport', ">= 3.0.0")
  s.add_development_dependency('rspec', "~> 2.6.0")
  s.add_development_dependency('yard', "~> 0.7.2")
  s.add_development_dependency('bundler', "~> 1.1.3")
  s.add_development_dependency('jeweler', "~> 1.6.4")
  s.add_development_dependency('simplecov', "~> 0.5.3")
  s.add_development_dependency('autotest', ">= 0")
  s.add_development_dependency('rdiscount', ">= 0")
end
