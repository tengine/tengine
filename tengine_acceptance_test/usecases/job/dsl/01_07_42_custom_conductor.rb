# -*- coding: utf-8 -*-
require 'tengine_job'

custom_conductor = lambda do |job|
  begin
    job.run
  rescue => e
    job.succeed
  end
end

jobnet('rjn0742') do
  ruby_job('rj1', :conductor => {:ruby_job => custom_conductor}){ raise RuntimeError }
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  ruby_job('rj3'){ raise RuntimeError }
  ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
end
