# -*- coding: utf-8 -*-

def common_develooment_dependencies(s)
  s.add_development_dependency('bundler', "~> 1.1.3")
  s.add_development_dependency('rake', "~> 0.9.2.2")
  s.add_development_dependency('rspec', "~> 2.10.0")
  s.add_development_dependency('yard', "~> 0.8.1")
  s.add_development_dependency('simplecov', "~> 0.6.4")
  s.add_development_dependency('autotest', ">= 0")
  s.add_development_dependency('rdiscount', ">= 0")
end


PackageDef = Struct.new(:package_type, :name, :dependencies)

PACKAGES = [
  PackageDef.new(:gem, 'tengine_support'        , %w[]),
  PackageDef.new(:gem, 'tengine_event'          , %w[tengine_support]),
  PackageDef.new(:gem, 'tengine_core'           , %w[tengine_support tengine_event]),
  PackageDef.new(:gem, 'tengine_resource'       , %w[tengine_support tengine_event tengine_core]),
  PackageDef.new(:gem, 'tengine_resource_ec2'   , %w[tengine_support tengine_event tengine_core tengine_resource]),
  PackageDef.new(:gem, 'tengine_resource_wakame', %w[tengine_support tengine_event tengine_core tengine_resource tengine_resource_ec2]),
  PackageDef.new(:gem, 'tengine_job'            , %w[tengine_support tengine_event tengine_core tengine_resource]),
  PackageDef.new(:gem, 'tengine_job_agent'      , %w[tengine_support tengine_event]),
  PackageDef.new(:rails, 'tengine_ui'           , %w[tengine_support tengine_event tengine_core tengine_resource tengine_job]),
]
