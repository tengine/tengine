# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0727", :instance_name => "test_server1", :credential_name => "test_credential1") do
  job('j1', "$HOME/tengine_job_test.sh 0 job1")
  jobnet("rjn1") do
    ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
    jobnet("rjn11") do
      ruby_job('rj3'){ STDOUT.puts('rj3 executiong...') }
      job('j1', "$HOME/tengine_job_test.sh 0 job1")
    end
  end
  ruby_job('rj4'){ STDOUT.puts('rj4 executing...') }
end
