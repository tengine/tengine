# -*- coding: utf-8 -*-
require 'tengine_job'

custom_conductor = lambda do |job|
  begin
    job.run
  rescue => e
    job.succeed
  end
end

jobnet('rjn0739', :conductors => {:ruby_job => custom_conductor}) do
  ruby_job('rj1'){ raise RuntimeError }
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
end
