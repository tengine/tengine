# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0002]
#              |--e2-->(j11)--e4-->|
# (S1)--e1-->[F1]                [J1]--e6-->(E1)
#              |--e3-->(j12)--e5-->|

require File.expand_path('test_credential_fixture', File.dirname(__FILE__))
require File.expand_path('test_server_fixture', File.dirname(__FILE__))

class Rjn0002SimpleParallelJobnetBuilder < JobnetFixtureBuilder
  include TestCredentialFixture
  include TestServerFixture

  DSL = <<-EOS
    jobnet("rjn0002", :server_name => "test_server1", :credential_name => "test_credential1") do
      boot_jobs("j11", "j12")
      job("j11", "job_test j11")
      job("j12", "job_test j12")
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0002", {
        :server_name => test_server1.name,
        :credential_name => test_credential1.name
      }.update(options || { }))
    root.children << new_start
    root.children << new_fork
    root.children << new_script("j11", :script => "job_test j11")
    root.children << new_script("j12", :script => "job_test j12")
    root.children << new_join
    root.children << new_end
    root.edges << new_edge(:S1, :F1)
    root.edges << new_edge(:F1, :j11)
    root.edges << new_edge(:F1, :j12)
    root.edges << new_edge(:j11, :J1)
    root.edges << new_edge(:j12, :J1)
    root.edges << new_edge(:J1, :E1)
    root.save!
    root
  end
end
