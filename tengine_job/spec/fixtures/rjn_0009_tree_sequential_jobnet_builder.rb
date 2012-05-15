# -*- coding: utf-8 -*-

require File.expand_path('test_credential_fixture', File.dirname(__FILE__))
require File.expand_path('test_server_fixture', File.dirname(__FILE__))

# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0009]
# [S1] --e1-->[j1100]--e2-->[j1200]--e3-->[j1300]--e4-->[j1400]--e5-->[j1500]--e6-->[j1600]--e7-->[E1]
#
# [j1100]
# [S2]--e8-->(j1110)--e9-->(j1120)--e10-->[E2]
#
# [j1200]
# [S3]--e11-->(j1210)--e12-->[E3]
#
# [j1300]
# [S4]--e13-->(j1310)--e14-->[E4]
#
# [j1400]
# [S5]--e15-->(j1410)--e16-->[E5]
#
# [j1500]
# [S6]--e17-->[j1510]--e18-->[E6]
#
# [j1510]
# [S7]--e19-->(j1511)--e20-->[E7]
#
# [j1600]
# [S8]--e21-->[j1610]--e22-->[j1620]--e23-->[j1630]--e24-->[E8]
#
# [j1610]
# [S9]--e25-->(j1611)--e26-->(j1612)--e27-->[E9]
#
# [j1620]
# [S10]--e28-->(j1621)--e29-->[E10]
#
# [j1630]
# [S11]--e30-->(j1631)--e31-->[E11]
class Rjn0009TreeSequentialJobnetBuilder < JobnetFixtureBuilder
  include TestCredentialFixture
  include TestServerFixture

  DSL = <<-EOS
    jobnet("rjn0009") do
      jobnet("j1100", :credential_name => "test_credential1", :server_name => "test_server1") do
        job("j1110", "job_test j1110")
        job("j1120", "job_test j1120")
      end
      jobnet("j1200", :credential_name => "test_credential1") do
        job("j1210", "job_test j1210", :server_name => "mysql_master")
      end
      jobnet("j1300", :server_name => "mysql_master") do
        job("j1310", "job_test j1310", :credential_name => "test_credential1")
      end
      jobnet("j1400") do
        job("j1410", "job_test j1410", :credential_name => "test_credential1", :server_name => "mysql_master")
      end
      jobnet("j1500", :credential_name => "test_credential1", :server_name => "mysql_master") do
        jobnet("j1510") do
          job("j1511", "job_test j1511")
        end
      end
      jobnet("j1600", :credential_name => "test_credential1", :server_name => "mysql_master") do
        jobnet("j1610") do
          job("j1611", "job_test j1611", :server_name => "test_server1") # server_nameを上書き
          job("j1612", "job_test j1612", :credential_name => "gohan_ssh_pk") # credential_nameを上書き
        end
        jobnet("j1620", :server_name => "test_server1") do # server_nameを上書き
          job("j1621", "job_test j1621")
        end
        jobnet("j1630", :credential_name => "gohan_ssh_pk") do # credential_nameを上書き
          job("j1631", "job_test j1631")
        end
      end
    end
  EOS

  def create(options = {})
    resource_fixture = GokuAtEc2ApNortheast.new
    resource_fixture.mysql_master

    root = new_root_jobnet("rjn0009", options)
    root.children << new_start
    root.children << new_jobnet("j1100", :credential_name => test_credential1.name, :server_name => test_server1.name)
    root.children << new_jobnet("j1200", :credential_name => test_credential1.name)
    root.children << new_jobnet("j1300", :server_name => "mysql_master")
    root.children << new_jobnet("j1400")
    root.children << new_jobnet("j1500", :credential_name => test_credential1.name, :server_name => "mysql_master")
    root.children << new_jobnet("j1600", :credential_name => test_credential1.name, :server_name => "mysql_master")
    root.children << new_end
    root.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(7)
    raise "edge count error: expected 7 but #{@edge_count}\n" << root.edges.map(&:inspect).join("\n  ") unless @edge_count == 7

    j1100 = self[:j1100]
    j1100.children << new_start
    j1100.children << new_script("j1110", :script => "job_test j1110")
    j1100.children << new_script("j1120", :script => "job_test j1120")
    j1100.children << new_end
    j1100.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(10)

    j1200 = self[:j1200]
    j1200.children << new_start
    j1200.children << new_script("j1210", :script => "job_test j1210", :server_name => "mysql_master")
    j1200.children << new_end
    j1200.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(12)

    j1300 = self[:j1300]
    j1300.children << new_start
    j1300.children << new_script("j1310", :script => "job_test j1310", :credential_name => test_credential1.name)
    j1300.children << new_end
    j1300.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(14)

    j1400 = self[:j1400]
    j1400.children << new_start
    j1400.children << new_script("j1410", :script => "job_test j1410", :server_name => "mysql_master", :credential_name => test_credential1.name)
    j1400.children << new_end
    j1400.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(16)

    j1500 = self[:j1500]
    j1500.children << new_start
    j1500.children << new_jobnet("j1510")
    j1500.children << new_end
    j1500.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(18)

    j1510 = self[:j1510]
    j1510.children << new_start
    j1510.children << new_script("j1511", :script => "job_test j1511")
    j1510.children << new_end
    j1510.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(20)

    j1600 = self[:j1600]
    j1600.children << new_start
    j1600.children << new_jobnet("j1610")
    j1600.children << new_jobnet("j1620", :server_name => test_server1.name)
    j1600.children << new_jobnet("j1630", :credential_name => "gohan_ssh_pk")
    j1600.children << new_end
    j1600.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(24)

    j1610 = self[:j1610]
    j1610.children << new_start
    j1610.children << new_script("j1611", :script => "job_test j1611", :server_name => test_server1.name)
    j1610.children << new_script("j1612", :script => "job_test j1612", :credential_name => "gohan_ssh_pk")
    j1610.children << new_end
    j1610.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(27)

    j1620 = self[:j1620]
    j1620.children << new_start
    j1620.children << new_script("j1621", :script => "job_test j1621")
    j1620.children << new_end
    j1620.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(29)

    j1630 = self[:j1630]
    j1630.children << new_start
    j1630.children << new_script("j1631", :script => "job_test j1631")
    j1630.children << new_end
    j1630.build_sequencial_edges{|edge| remember_edge(edge)}
    check_edge_count(31)

    root.save!
    root
  end
end
