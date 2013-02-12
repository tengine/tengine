# -*- coding: utf-8 -*-

require 'tengine_job'

jobnet("rjn0025") do
  # jon_method指定なし
  jobnet("jn1", :server_name => "test_server1", :credential_name => "test_credential1") do
    ssh_job('j11', "job_test j11") # ssh_job
    ssh_job('j12', "job_test j12")
    ruby_job('j13'){ puts "j13"}
  end

  # jon_method :ruby_job
  jobnet("jn2", job_method: :ruby_job, :server_name => "test_server1", :credential_name => "test_credential1") do
    job('j21'){ puts "j21" } # ruby_job
    ssh_job('j22', "job_test j22")
    ruby_job('j23'){ puts "j23"}
  end

  # jon_method :ssh_job
  jobnet("jn3", job_method: :ssh_job, :server_name => "test_server1", :credential_name => "test_credential1") do
    job('j31', "job_test j31") # ssh_job
    ssh_job('j32', "job_test j32")
    ruby_job('j33'){ puts "j33"}
  end
end
