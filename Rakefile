# encoding: utf-8
require 'rubygems'
require 'rake'

version_path = File.expand_path("../TENGINE_VERSION", __FILE__)
version = File.read(version_path).strip

OUTDATED_THRESHOLDS = {
  :total => 100,
  :unique => 20,
  :average => 10,
  :ignored => %w[amq-protocol amq-client amqp mongo mongoid]
}


PackageDef = Struct.new(:package_type, :name, :dependencies)

packages = [
  PackageDef.new(:gem, 'tengine_support'  , %w[]),
  PackageDef.new(:gem, 'tengine_event'    , %w[tengine_support]),
  PackageDef.new(:gem, 'tengine_core'     , %w[tengine_support tengine_event]),
  PackageDef.new(:gem, 'tengine_resource' , %w[tengine_support tengine_event tengine_core]),
  PackageDef.new(:gem, 'tengine_job'      , %w[tengine_support tengine_event tengine_core tengine_resource]),
  PackageDef.new(:gem, 'tengine_job_agent', %w[tengine_support tengine_event]),
  PackageDef.new(:rails, 'tengine_ui'     , %w[tengine_support tengine_event tengine_core tengine_resource tengine_job]),
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

    case package.package_type
    when :gem then
      cmd << "rm -rf pkg/*"
      cmd << "bundle exec rake gem"
    end

    system(cmd.join(' && ')) || errors << package.name
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end

desc "Run spec task for all projects"
task :spec do
  ENV['GEM'] = packages.map(&:name).join(',')
  require File.expand_path("../ci/travis.rb", __FILE__)
end

%w(package gem).each do |task_name|
  desc "Run #{task_name} task for all projects"
  task(task_name) do
    errors = []
    packages.each do |package|
      system(%(cd #{package.name} && bundle exec rake #{task_name})) || errors << package.name
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

desc "Run bundle outdated for all projects"
task :outdated do
  ignored = OUTDATED_THRESHOLDS[:ignored]

  output = {}
  packages.each do |package|
    raw_output = `cd #{package.name} && bundle outdated`
    entries = raw_output.scan(%r{\s*\*\s*(.+) \((.+) \> (.+)\)})
    entries.reject!{|entry| ignored.include?(entry.first) }
    output[package.name] = entries
  end

  total_count = output.values.inject(0){|sum, entries| sum += entries.length}
  package_counts = output.values.map{|entries| entries.map{|items| items[0, 2]} }.sort.
    inject({}) do |d, entries|
      entries.each{|entry| d[entry] ||= 0; d[entry] += 1}
      d
    end
  counts_each_package = output.inject({}){|d, (name,entries)| d[name] = entries.length; d}
  most_entries_package = counts_each_package.keys.max_by{|key| counts_each_package[key]}

  result = {
    :total => total_count,
    :unique => package_counts.length,
    :average => 1.0 * total_count / counts_each_package.length,
  }

  puts "total outdated dependencies: #{result[:total]}"
  puts "unique outdated libraries: #{result[:unique]}"
  puts "outdated dependencies average: #{result[:average]}"
  puts "package which has most outdated dependencies: #{most_entries_package} #{counts_each_package[most_entries_package]}"

  fail("too many outdated dependecies:#{result.inspect} thresholds:#{OUTDATED_THRESHOLDS}") if result.any?{|k,v| v >= OUTDATED_THRESHOLDS[k]}
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
