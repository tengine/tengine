# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "tengine_job_agent"
  gem.homepage = "http://github.com/tengine/tengine_job_agent"
  gem.license = "MPL2.0/LGPLv3"
  gem.summary = %Q{tengine_job_agent invoke job, watches it and notify its finish to tengine server}
  gem.description = %Q{tengine_job_agent works with tengine_job}
  gem.email = "tengine-info@groovenauts.jp"
  gem.authors = %w[taigou totty g-morita shyouhei akm]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
