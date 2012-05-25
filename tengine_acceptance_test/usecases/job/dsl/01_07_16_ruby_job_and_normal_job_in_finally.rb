# -*- coding: utf-8 -*-
require 'tengine_job'

jobnet("rjn0716", :instance_name => "test_server1", :credential_name => "test_credential1") do
  ruby_job('rj1', :to => ['rj2', 'rj3']){ STDOUT.puts('rj1 executing...') }
  ruby_job('rj2', :to => 'rj4'         ){ STDOUT.puts('rj2 executing...') }
  ruby_job('rj3', :to => 'rj4'         ){ STDOUT.puts('rj3 executing...') }
  ruby_job('rj4'                       ){ STDOUT.puts('rj4 executing...') }
  finally do
    ruby_job('frj1'){ STDOUT.puts('frj1 executing...') }
    job('fj1', "$HOME/tengine_job_test.sh 0 job1_in_finally")
    ruby_job('frj2'){ STDOUT.puts('frj2 executing...') }
  end
end
