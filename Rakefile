# encoding: utf-8
require 'rubygems'
require 'rake'

version_path = File.expand_path("../TENGINE_VERSION", __FILE__)
version = File.read(version_path).strip

PackageDef = Struct.new(:name, :dependencies)

packages = [
  PackageDef.new('tengine_support'  , %w[]),
  PackageDef.new('tengine_event'    , %w[tengine_support]),
  PackageDef.new('tengine_core'     , %w[tengine_support tengine_event]),
  PackageDef.new('tengine_resource' , %w[tengine_support tengine_event tengine_core]),
  PackageDef.new('tengine_job'      , %w[tengine_support tengine_event tengine_core tengine_resource]),
  PackageDef.new('tengine_job_agent', %w[tengine_support tengine_event]),
]

desc "install other tengine gems and bundle install"
task :rebuild do
  errors = []
  packages.each do |package|
    puts "=" * 80
    puts "rebuilding #{package.name}"
    cmd = []
    cmd << "cd #{package.name}"
    package.dependencies.each do |dep|
      cmd << "gem uninstall #{dep} -a -I -x"
    end
    package.dependencies.each do |dep|
      cmd << "gem install ../#{dep}/pkg/#{dep}-#{version}.gem"
    end
    cmd << "bundle install"
    cmd << "rm -rf pkg/*"
    cmd << "bundle exec rake gem"
    system(cmd.join(' && ')) || errors << package.name
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end


%w(spec package gem).each do |task_name|
  desc "Run #{task_name} task for all projects"
  task(task_name) do
    errors = []
    packages.each do |package|
      system(%(cd #{package.name} && bundle exec rake #{task_name})) || errors << package.name
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

namespace :version do
  desc "increment the last number of version"
  task :inc do
    array = version.split(/\./)
    pair = array.pop
    str, num = *pair.scan(/(\D*)?(\d+)/).flatten
    array.push(str + num.to_i.succ.to_s)
    result = array.join(".")
    puts "#{File.basename(version_path)}: #{result}"
    File.open(version_path, "w"){|f| f.puts(result)}
  end
end

namespace :gemsets do
  desc "create gemsets each packages"
  task :create do
    packages.each do |package|
      system("rvm gemset create #{package.name}")
      rvmrc = "rvm %s@%s" % [ENV['RUBY_VERSION'] || 'ruby-1.9.3-head', package.name]
      File.open("#{package.name}/.rvmrc", 'w'){|f| f.puts(rvmrc)}
    end
  end

  desc "delete gemsets each packages"
  task :delete do
    packages.each do |package|
      system("rvm --force gemset delete #{package.name}")
    end
  end
end
