# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn07087", :instance_name => "test_server1", :credential_name => "test_credential1") do
  boot_jobs(['rj1', 'j1'])
  ruby_job('rj1', :to => 'rj1'){ STDOUT.puts('rj1 executing...') }
  ruby_job('j1', "$HOME/tengine_job_test.sh 0 job1", :to => 'rj2')
  ruby_job('rj2', :to => 'rj3'){ STDOUT.puts('rj2 executing...') }
  ruby_job('rj3'              ){ STDOUT.puts('rj3 executing...') }
end
