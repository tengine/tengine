# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0734") do
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  finally do
    jobnet("rfjn1") do
      ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
      jobnet("rfjn11", :instance_name => "test_server1", :credential_name => "test_credential1") do
        ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
        job('j1', "$HOME/tengine_job_test.sh 0 job1")
        ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
      end
      ruby_job('rj5'){ STDOUT.puts('rj5 executing...') }
    end
  end
end
