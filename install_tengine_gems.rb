#!/usr/bin/env ruby

require File.expand_path("../dependencies", __FILE__)

version_path = File.expand_path("../TENGINE_VERSION", __FILE__)
version = File.read(version_path).strip

package_name = File.basename(Dir.pwd)

package = PACKAGES.detect{|package| package.name == package_name}
unless package
  STDERR.puts("package not found #{package_name}. Please call this after cd path/to/tengine/tengine_gem_package.")
  exit(1)
end

puts "no dependencies" if package.dependencies.empty?

def system_with_verbose(cmd)
  puts(cmd)
  system(cmd)
end

package.dependencies.each do |dep|
  system_with_verbose "gem uninstall #{dep}  -a -I -x"
end
package.dependencies.each do |dep|
  system_with_verbose "gem install ../#{dep}/pkg/#{dep}-#{version}.gem"
end
