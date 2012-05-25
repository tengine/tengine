# -*- coding: utf-8 -*-
require 'tengine_job'

custom_conductor = lambda do |job|
  begin
    job.run
  rescue => e
    job.succeed
  end
end

jobnet('rjn0744') do
  ruby_job('rj1', :conductor => {:ruby_job => custom_conductor}){ raise RuntimeError }
  jobnet('rjn1') do
    ruby_job('rj2', :conductor => {:ruby_job => Tengine::Job::RubyJob::DEFAULT_CONDUCTOR}){ raise RuntimeError }
  end
  ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
end
