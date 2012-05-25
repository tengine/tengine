# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0745") do
  ruby_job('rj1'){ job.succeed(:message => "succeeded rj1 by explicitly coding"); STDOUT.puts('rj1 executing...') }
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
end
