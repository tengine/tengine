# -*- coding: utf-8 -*-

def common_development_dependencies(s)
  s.add_development_dependency('bundler') # any
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', "~> 2.10.0")
  s.add_development_dependency('yard')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('autotest')
  s.add_development_dependency('rdiscount')
  s.add_development_dependency('pry')
  s.add_development_dependency('pry-remote')
  s.add_development_dependency('pry-stack_explorer')
  s.add_development_dependency('pry-debugger')
end


PackageDef = Struct.new(:package_type, :name, :dependencies)

PACKAGES = [
  PackageDef.new(:gem, 'tengine_support'        , %w[]),
  PackageDef.new(:gem, 'tengine_event'          , %w[tengine_support]),
  PackageDef.new(:gem, 'tengine_rails_plugin'   , %w[tengine_support tengine_event]),
  PackageDef.new(:gem, 'tengine_core'           , %w[tengine_support tengine_event]),
  PackageDef.new(:gem, 'tengine_resource'       , %w[tengine_support tengine_event tengine_core]),
  PackageDef.new(:gem, 'tengine_resource_ec2'   , %w[tengine_support tengine_event tengine_core tengine_resource]),
  PackageDef.new(:gem, 'tengine_resource_wakame', %w[tengine_support tengine_event tengine_core tengine_resource tengine_resource_ec2]),
  PackageDef.new(:gem, 'tengine_job'            , %w[tengine_support tengine_event tengine_core tengine_resource tengine_resource_ec2]),
  PackageDef.new(:gem, 'tengine_job_agent'      , %w[tengine_support tengine_event]),
  PackageDef.new(:rails, 'tengine_ui'           , %w[tengine_support tengine_event tengine_core tengine_resource tengine_resource_ec2 tengine_resource_wakame tengine_job]),
]
