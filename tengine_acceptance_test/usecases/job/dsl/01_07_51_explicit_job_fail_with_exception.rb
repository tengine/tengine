# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0751") do
  ruby_job('rj1'){ job.fail(:exception => RuntimeError.new("failed rj1 by explicitly coding")); STDOUT.puts('rj1 executing...') }
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  finally do
    ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  end
end
