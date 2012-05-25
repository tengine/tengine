# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0722", :instance_name => "test_server1", :credential_name => "test_credential1") do
  job('j1', "$HOME/tengine_job_test.sh 0 job1")
  ruby_job('rj1'){ STDOUT.puts('rj1 executing...') }
  jobnet("rjn1") do
    ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
  end
  ruby_job('rj3'){ STDOUT.puts('rj3 executing...') }
end
