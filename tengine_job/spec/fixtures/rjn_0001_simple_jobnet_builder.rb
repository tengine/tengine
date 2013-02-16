# -*- coding: utf-8 -*-

require File.expand_path('test_credential_fixture', File.dirname(__FILE__))
require File.expand_path('test_server_fixture', File.dirname(__FILE__))

# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0001]
# (S1) --e1-->(j11)--e2-->(j12)--e3-->(E1)

class Rjn0001SimpleJobnetBuilder < JobnetFixtureBuilder
  include TestCredentialFixture
  include TestServerFixture

  public :test_server1
  public :test_credential1

  DSL = <<-EOS
    jobnet("rjn0001", :server_name => "test_server1", :credential_name => "test_credential1") do
      auto_sequence
      job("j11", "job_test j11")
      job("j12", "job_test j12")
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0001", {
        :server_name => test_server1.name,
        :credential_name => test_credential1.name
      }.update(options || { }))
    root.children << new_start
    root.children << new_script("j11", :script => "job_test j11")
    root.children << new_script("j12", :script => "job_test j12")
    root.prepare_end
    root.build_sequencial_edges
    root.save!
    self[:S1] = root.children[0]
    self[:E1] = root.children[3]
    self[:e1] = root.edges[0]
    self[:e2] = root.edges[1]
    self[:e3] = root.edges[2]
    root
  end
end
