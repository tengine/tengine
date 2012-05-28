# -*- encoding: utf-8 -*-

version = File.read(File.expand_path("../../TENGINE_VERSION", __FILE__)).strip
require File.expand_path("../../dependencies", __FILE__)

Gem::Specification.new do |s|
  s.name = "tengine_job_agent"
  s.version = version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["taigou", "totty", "g-morita", "shyouhei", "akm"]
  # s.date = "2012-02-09"
  s.description = "tengine_job_agent works with tengine_job"
  s.email = "tengine-info@groovenauts.jp"
  s.executables = ["tengine_job_agent_kill", "tengine_job_agent_run", "tengine_job_agent_watchdog"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = Dir["Gemfile", "Gemfile.lock", "README.rdoc", "bin/**/*", "lib/**/*", ]
  s.homepage = "http://github.com/tengine/tengine_job_agent"
  s.licenses = ["MPL2.0/LGPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.12"
  s.summary = "tengine_job_agent invoke job, watches it and notify its finish to tengine server"

  s.add_runtime_dependency('tengine_support', "~> #{version}")
  s.add_runtime_dependency('tengine_event', "~> #{version}")

  common_develooment_dependencies(s)
  s.add_development_dependency('ci_reporter', "~> 1.6.5")
end
