require 'rubygems'
require 'rubygems/package_task'
require 'bundler'
require 'rake'

def tengine_common_tasks(gemspec_name)

  spec = eval(File.read(gemspec_name))

  begin
    Bundler.setup(:default, :development)
  rescue Bundler::BundlerError => e
    $stderr.puts e.message
    $stderr.puts "Run `bundle install` to install missing gems"
    exit e.status_code
  end

  Gem::PackageTask.new(spec) do |p|
    p.gem_spec = spec
  end

  desc "Release to gemcutter"
  task :release => :package do
    require 'rake/gemcutter'
    Rake::Gemcutter::Tasks.new(spec).define
    Rake::Task['gem:push'].invoke
  end

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

end
