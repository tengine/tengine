# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0755") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  expansion('rjn0755_2')
  ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
end

jobnet('rjn0755_2') do
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  expansion('rjn0755_3')
  ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
end

jobnet('rjn0755_3') do
  ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
end
