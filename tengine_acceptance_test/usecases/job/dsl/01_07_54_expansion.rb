# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0754") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  expansion('rjn0754_2')
  ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
end

jobnet('rjn0754_2') do
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
end
