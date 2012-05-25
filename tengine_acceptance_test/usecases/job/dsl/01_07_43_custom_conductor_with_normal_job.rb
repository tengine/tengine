require 'tengine_job'

custom_conductor = lambda do |job|
  begin
    job.run
  rescue => e
    job.succeed
  end
end

jobnet('rjn0743', :instance_name => "test_server1", :credential_name => "test_credential1") do
  job('j1', "$HOME/tengine_job_test.sh 0 job1")
  ruby_job('rj1', :conductor => {:ruby_job => custom_conductor}){ raise RuntimeError }
  ruby_job('rj2'){ STDOUT.puts('rj2 executing...') }
end
