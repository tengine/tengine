# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0747") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  jobnet("rjn1") do
    ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  end
  ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
  finally do
    ruby_job('rj4'){ job.succeed(:message => "succeeded rj4 by explicitly coding"); STDOUT.puts('rj4 executing...') }
  end
end
