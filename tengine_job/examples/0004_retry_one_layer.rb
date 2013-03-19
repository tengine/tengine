# -*- coding: utf-8 -*-

require 'tengine_job'

# [jn0004]
#               |-->[j2]-->
#               |         |
# [S1]-->[j1]-->          |-->[j4]-->[E1]
#               |-->[j3]-->
#                     _________finally________
#                    {                        }
#                    {[S2]-->[jn0004_f]-->[E2]}
#                    {________________________}
#

base_dir = File.expand_path("..", __FILE__)

jobnet("jn0004", :server_name => "localhost", :credential_name => "ssh_pk") do
  boot_jobs("j1")
  job("j1", "#{base_dir}/0004_retry_one_layer.sh", :to => ["j2", "j3"])
  job("j2", "#{base_dir}/0004_retry_one_layer.sh", :to => "j4")
  job("j3", "#{base_dir}/0004_retry_one_layer.sh", :to => "j4")
  job("j4", "#{base_dir}/0004_retry_one_layer.sh")
  finally do
    job("jn0004_f", "#{base_dir}/0004_retry_one_layer.sh")
  end
end
