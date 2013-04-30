#!/usr/bin/env ruby

pid, name = *ARGV

open("tmp/ssh_job#{pid}", "a") do |f|
  f.puts("#{Time.now.to_s} #{pid} #{name} start")
  sleep(ENV['SLEEP'] || 10)
  f.puts("#{Time.now.to_s} #{pid} #{name} finish")
end
