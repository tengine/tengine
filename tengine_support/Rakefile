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
  gem.name = "tengine_support"
  gem.homepage = "http://github.com/tengine/tengine_support"
  gem.license = "MPL/LGPL"
  gem.summary = "tengine_support provides utility classes/modules which isn't included in active_support."
  gem.description = "tengine_support provides utility classes/modules which is not included in active_support. It doesn't depend on other tengine gems."
  gem.email = "tengine-info@groovenauts.jp"
  gem.authors = %w[shyouhei akm taigou]
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
task :test => :spec # for rubygems-test

require 'yard'
YARD::Rake::YardocTask.new
