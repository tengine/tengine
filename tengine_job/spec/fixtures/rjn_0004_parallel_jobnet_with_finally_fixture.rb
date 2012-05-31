# -*- coding: utf-8 -*-

require File.expand_path('test_credential_fixture', File.dirname(__FILE__))
require File.expand_path('test_server_fixture', File.dirname(__FILE__))

# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [jn0004]
#                         |--e3-->(j2)--e5-->|
# (S1)--e1-->(j1)--e2-->[F1]                [J1]--e7-->(j4)--e8-->(E1)
#                         |--e4-->(j3)--e6-->|
#
# in [jn0004/finally]
# (S2) --e9-->(jn0004_f)-e10-->(E2)

class Rjn0004ParallelJobnetWithFinally < JobnetFixtureBuilder
  include TestCredentialFixture
  include TestServerFixture

  DSL = <<-EOS
    jobnet("jn0004", :instance_name => "test_server1", :credential_name => "test_credential1") do
      boot_jobs("j1")
      job("j1", "$HOME/0004_retry_one_layer.sh", :to => ["j2", "j3"])
      job("j2", "$HOME/0004_retry_one_layer.sh", :to => "j4")
      job("j3", "$HOME/0004_retry_one_layer.sh", :to => "j4")
      job("j4", "$HOME/0004_retry_one_layer.sh")
      finally do
        job("jn0004_f", "$HOME/0004_retry_one_layer.sh")
      end
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("jn0004", {
        :server_name => test_server1.name,
        :credential_name => test_credential1.name
      }.update(options || { }))
    root.children << new_start
    root.children << new_script("j1", :script => "$HOME/0004_retry_one_layer.sh")
    root.children << new_fork
    root.children << new_script("j2", :script => "$HOME/0004_retry_one_layer.sh")
    root.children << new_script("j3", :script => "$HOME/0004_retry_one_layer.sh")
    root.children << new_join
    root.children << new_script("j4", :script => "$HOME/0004_retry_one_layer.sh")
    root.children << new_finally
    root.children << new_end
    root.edges << new_edge(:S1, :j1)
    root.edges << new_edge(:j1, :F1)
    root.edges << new_edge(:F1, :j2)
    root.edges << new_edge(:F1, :j3)
    root.edges << new_edge(:j2, :J1)
    root.edges << new_edge(:j3, :J1)
    root.edges << new_edge(:J1, :j4)
    root.edges << new_edge(:j4, :E1)
    root.finally_vertex do |finally|
      finally.children << new_start
      finally.children << new_script("jn0004_f", :script => "$HOME/0004_retry_one_layer.sh")
      finally.children << new_end
      finally.edges << new_edge(:S2, :jn0004_f)
      finally.edges << new_edge(:jn0004_f, :F2)
    end
    root.save!
    root
  end
end
