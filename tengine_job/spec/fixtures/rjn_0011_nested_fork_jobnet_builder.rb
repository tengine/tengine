# -*- coding: utf-8 -*-

require File.expand_path('test_credential_fixture', File.dirname(__FILE__))
require File.expand_path('test_server_fixture', File.dirname(__FILE__))

# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0011]
# (S1)--e1-->[j1100]--e2-->(j1200)--e3-->[j1300]--e4-->(E1)
#
# in [j1100]
# (S2)--e5-->(j1110)--e6-->[j1120]--e7-->[j1130]--e8-->(j1140)--e9-->(E2)
#
# in [j1120]
# (S3)--e10-->(j1121)--e11-->(E3)
#
# in [j1130]
# (S4)--e12-->(j1131)--e13-->(E4)
#
# in [j1300]
# (S5)--e14-->(j1310)--e15-->(E5)
#
class Rjn0011NestedForkJobnetBuilder < JobnetFixtureBuilder
  include TestCredentialFixture
  include TestServerFixture

  DSL = <<-EOS
    jobnet("rjn0011", :server_name => "test_server1", :credential_name => "test_credential1") do
      auto_sequence
      jobnet("j1100") do
        job("j1110", "job_test j1110")
        jobnet("j1120") do
          job("j1121", "job_test j1121")
        end
        jobnet("j1130") do
          job("j1131", "job_test j1131")
        end
        job("j1140", "job_test j1140")
      end
      job("j1200", "job_test j1200")
      jobnet("j1300") do
        job("j1310", "job_test j1310")
      end
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0011", :server_name => test_server1.name, :credential_name => test_credential1.name)
    root.children << new_start
    root.children << new_jobnet("j1100")
    root.children << new_script("j1200", :script => "job_test j1200")
    root.children << new_jobnet("j1300")
    root.children << new_end
    root.edges << new_edge(:S1   , :j1100)
    root.edges << new_edge(:j1100, :j1200)
    root.edges << new_edge(:j1200, :j1300)
    root.edges << new_edge(:j1300, :E1  )
    self[:j1100].tap do |j1100|
      j1100.children << new_start
      j1100.children << new_script("j1110", :script => "job_test j1110")
      j1100.children << new_jobnet("j1120")
      j1100.children << new_jobnet("j1130")
      j1100.children << new_script("j1140", :script => "job_test j1140")
      j1100.children << new_end
      j1100.edges << new_edge(:S2   , :j1110)
      j1100.edges << new_edge(:j1110, :j1120)
      j1100.edges << new_edge(:j1120, :j1130)
      j1100.edges << new_edge(:j1130, :j1140)
      j1100.edges << new_edge(:j1140, :E2   )
    end
    self[:j1120].tap do |j1120|
      j1120.children << new_start
      j1120.children << new_script("j1121", :script => "job_test j1121")
      j1120.children << new_end
      j1120.edges << new_edge(:S3   , :j1121)
      j1120.edges << new_edge(:j1121, :E3   )
    end
    self[:j1130].tap do |j1130|
      j1130.children << new_start
      j1130.children << new_script("j1131", :script => "job_test j1131")
      j1130.children << new_end
      j1130.edges << new_edge(:S4   , :j1131)
      j1130.edges << new_edge(:j1131, :E4   )
    end
    self[:j1300].tap do |j1300|
      j1300.children << new_start
      j1300.children << new_script("j1310", :script => "job_test j1310")
      j1300.children << new_end
      j1300.edges << new_edge(:S5   , :j1310)
      j1300.edges << new_edge(:j1310, :E5   )
    end
    root.save!
    root
  end
end
