# encoding: utf-8
require 'rubygems'
require 'rake'
require 'erb'
require 'yaml'

require File.expand_path("../dependencies", __FILE__)

version_path = File.expand_path("../TENGINE_VERSION", __FILE__)
version = File.read(version_path).strip

OUTDATED_THRESHOLDS = {
  :unique => 18,
  :average => 7,
  :total => 50,
  :ignored => %w[amq-protocol amq-client amqp eventmachine mongo mongoid bson bson_ext]
}

task default: [:build, :spec]

namespace :bundle do
  desc "bundle install for each packgage"
  task :install do
    errors = []
    PACKAGES.each do |package|
      puts "=" * 80
      puts "bundle install for #{package.name}"
      cmd = []
      cmd << "cd #{package.name}"
      cmd << "bundle install"
      system(cmd.join(' && ')) || errors << package.name
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end

  desc "bundle update for each package"
  task :update do
    errors = []
    PACKAGES.each do |package|
      puts "=" * 80
      puts "bundle update for #{package.name}"
      cmd = []
      cmd << "cd #{package.name}"
      cmd << "bundle update"
      system(cmd.join(' && ')) || errors << package.name
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

desc "bundle install and install each gem"
task :build do
  errors = []
  PACKAGES.each do |package|
    puts "=" * 80
    puts "building #{package.name}"
    cmd = []
    cmd << "cd #{package.name}"
    cmd << "gem uninstall #{package.name} -a -I -x"
    cmd << "bundle install"
    case package.package_type
    when :gem then
      cmd << "rm -rf pkg/*"
      cmd << "bundle exec rake package"
      cmd << "gem install pkg/#{package.name}-*.gem --ignore-dependencies"
    end

    system(cmd.join(' && ')) || errors << package.name
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end

desc "install other tengine gems and bundle install"
task :rebuild do
  errors = []
  PACKAGES.each do |package|
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
  ENV['GEM'] = PACKAGES.map(&:name).join(',')
  require File.expand_path("../ci/travis.rb", __FILE__)
end

%w(package gem).each do |task_name|
  desc "Run #{task_name} task for all projects"
  task(task_name) do
    errors = []
    PACKAGES.each do |package|
      system(%(cd #{package.name} && bundle exec rake #{task_name})) || errors << package.name
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

desc "Run bundle outdated for all projects"
task :outdated do
  ignored = OUTDATED_THRESHOLDS[:ignored]

  output = {}
  PACKAGES.each do |package|
    puts "\n\e[1;33m[#{package.name}] bundele outdated\e[m\n"
    raw_output = `cd #{package.name} && bundle outdated`
    puts raw_output
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
  puts "package which has most outdated dependencies: #{most_entries_package} #{counts_each_package[most_entries_package]}"
  puts "outdated dependencies average: #{result[:average]}"
  puts "unique outdated library count: #{result[:unique]}"
  puts "unique outdated libraries:#{package_counts.inspect}"

  if result.any?{|k,v| v >= OUTDATED_THRESHOLDS[k]}
    fail("too many outdated dependecies:#{result.inspect} thresholds:#{OUTDATED_THRESHOLDS}")
  else
    puts "OK! It's under thresholds"
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
    PACKAGES.each do |package|
      system("rvm gemset create #{package.name}")
      rvmrc = "rvm %s@%s" % [ENV['RUBY_VERSION'] || 'ruby-1.9.3-head', package.name]
      File.open("#{package.name}/.rvmrc", 'w'){|f| f.puts(rvmrc)}
    end
  end

  desc "delete gemsets each packages"
  task :delete do
    PACKAGES.each do |package|
      system("rvm --force gemset delete #{package.name}")
    end
  end
end


namespace :travis do
  desc "generate .travis.yml from .travis.yml.erb"
  task :gen do
    path = File.expand_path("../.travis.yml.erb", __FILE__)
    erb = ERB.new(File.read(path))
    erb.filename = path
    result = erb.result
    YAML.load(result) # validation
    dest = File.expand_path("../.travis.yml", __FILE__)
    File.open(dest, "w"){|f| f.puts(result)}
    puts "#{dest} was generated successfully."
  end
end

desc "take profile of tengined"
file 'profile' do

  # create a temporary directory
  require 'tmpdir'
  root = File.dirname __FILE__
  Dir.mktmpdir do |dir|
    begin
      STDOUT.write 'generating handlers...'
      1024.times do |i|
        open(dir + "/profile#{i}.rb", 'w') do |fp|
          fp.puts 'require "tengine/core"'
          fp.puts "class Profile#{i}"
          fp.puts "include Tengine::Core::Driveable"
          fp.puts "on:profile#{i}"
          fp.puts "def profile#{i}"
          fp.puts "Process.kill 2, 0" if i.zero?
          fp.puts "end"
          fp.puts "end"
        end
      end
      puts

      STDOUT.write 'generating feeder...'
      open(dir + '/feeder.rb', 'w') do |fp|
        fp.puts <<-'end_'
          if $0 == __FILE__
            require "bundler/setup"
            require "tengine/event"
            require "eventmachine"
            require "logger"
            Tengine.logger = Logger.new STDOUT
            EM.run do
              s = Tengine::Event::Sender.new
              s.fire "profile1", :keep_connection => true do # initiate
                1023.downto 0 do |i|
                  s.fire "profile#{i}", :keep_connection => true do
                    if i.zero?
                      s.stop do
                        Tengine.logger.info "event send complete."
                        EM.stop
                      end
                    end
                  end
                end
              end
            end
          end
        end_
      end
      puts

      # put Gemfile
      open(dir + '/Gemfile', 'w') do |fp|
        fp.puts 'source "http://rubygems.org"'
        fp.puts "gem 'mongo', '1.6.2'"
        %w'tengine_core tengine_event tengine_job tengine_resource tengine_support'.each do |i|
          fp.puts "gem '#{i}', :path => '#{root}/#{i}'"
        end
      end
      puts 'bundle install'
      system 'bundle install', :chdir => dir

      env = { 'tengined_profile' => 'true' }
      tengined = spawn env, "bundle exec tengined --tengined-cache-drivers -k start -T #{dir}", :chdir => dir, :err => root+'/profile'
      feeder = spawn 'bundle exec ruby feeder.rb', :chdir => dir
    ensure
      begin
        Process.waitall
      rescue Interrupt
        retry
      end
    end
  end
  next true
end

# 
# Local Variables:
# mode: ruby
# coding: utf-8
# End:
