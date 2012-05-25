# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0753") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  finally do
    ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
    ruby_job('rj4'){ job.fail(:exception => RuntimeError.new("failed rj4 by explicitly coding")); STDOUT.puts('rj4 executing...') }
    ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
  end
end
