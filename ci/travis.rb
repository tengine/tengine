#!/usr/bin/env ruby

require 'fileutils'
include FileUtils

class Build
  attr_reader :component, :options

  def initialize(component, options = {})
    @component = component
    @options = options
  end

  def run!(options = {})
    self.options.update(options)
    Dir.chdir(dir) do
      announce(heading)
      setup_tengine_ui if dir == "tengine_ui"
      rake(*tasks)
    end
  end

  def setup_tengine_ui
    FileUtils.cp("config/mongoid.yml.example", "config/mongoid.yml")
  end

  def announce(heading)
    puts "\n\e[1;33m[Travis CI] #{heading}\e[m\n"
  end

  def heading
    heading = [gem]
    heading.join(' ')
  end

  def tasks
    ["spec"]
  end

  def key
    key = [gem]
    key.join(':')
  end

  def gem
    component
  end
  alias :dir :gem

  def adapter
    component.split(':').last
  end

  def rake(*tasks)
    tasks.each do |task|
      cmd = %w'bundle exec rake' << task
      puts "Running command: #{cmd.inspect}"
      return false unless system({'RUBYOPT' => '-d'}, *cmd)
    end
    true
  end
end

results = {}

ENV['GEM'].split(',').each do |gem|
  build = Build.new(gem)
  results[build.key] = build.run!
end

# puts
# puts "Build environment:"
# puts "  #{`cat /etc/issue`}"
# puts "  #{`uname -a`}"
# puts "  #{`ruby -v`}"
# `gem env`.each_line {|line| print "   #{line}"}
# puts "   Bundled gems:"
# `bundle show`.each_line {|line| print "     #{line}"}
# puts "   Local gems:"
# `gem list`.each_line {|line| print "     #{line}"}

failures = results.select { |key, value| value == false }

if failures.empty?
  puts
  puts "tengine build finished successfully"
  exit(true)
else
  puts
  puts "tengine build FAILED"
  puts "Failed components: #{failures.map { |component| component.first }.join(', ')}"
  exit(false)
end
