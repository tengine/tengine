# -*- coding: utf-8 -*-
require 'tengine_job'

custom_conductor = lambda do |job|
  begin
    job.run
  rescue => e
    job.succeed
  end
end

jobnet('rjn0741', :conductors => {:ruby_job => custom_conductor}) do
  ruby_job('rj1'){ raise RuntimeError }
  jobnet('rjn1', :conductors => {:ruby_job => Tengine::Job::RubyJob::DEFAULT_CONDUCTOR}) do
    ruby_job('rj2'){ raise RuntimeError }
  end
  ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
end
