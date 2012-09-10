# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip
require File.expand_path("../../dependencies", __FILE__)

Gem::Specification.new do |s|
  s.name = "tengine_support"
  s.version = version

  # s.platform    = Gem::Platform::RUBY # I wish tengine was able to work on JRuby too.
  # s.required_ruby_version = '>= 1.9.3'

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["shyouhei", "akm", "taigou"]
  # s.date = "2012-05-23"
  s.description = "tengine_support provides utility classes/modules which is not included in active_support. It doesn't depend on other tengine gems."
  s.email = "tengine-info@groovenauts.jp"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = Dir["Gemfile", "README.md", "lib/**/*"]

  s.homepage = "https://github.com/tengine/tengine/tree/develop/tengine_support"
  s.licenses = ["MPL/LGPL"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary = "tengine_support provides utility classes/modules which isn't included in active_support."

  s.add_runtime_dependency('activesupport', ">= 3.0.0")

  common_development_dependencies(s)
end
