# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0025]
#                         |--e3-->(j2)--e5-->|
# (S1)--e1-->(j1)--e2-->[F1]               [J1]--e7-->(j4)--e8-->(E1)
#                         |--e4-->(j3)--e6-->|

class Rjn0025JobMethodFixture < JobnetFixtureBuilder

  DSL = <<-EOS
    jobnet("rjn0025") do
       # jon_method指定なし
      jobnet("jn1", :server_name => "test_server1", :credential_name => "test_credential1") do
        job('j11'){ puts "j11" } # ruby_job
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
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0025", options)
    root.children << new_start
    root.children << new_jobnet("jn1")
    root.children << new_jobnet("jn2")
    root.children << new_jobnet("jn3")
    root.children << new_end
    root.edges << new_edge(:S1 , :jn1)
    root.edges << new_edge(:jn1, :jn2)
    root.edges << new_edge(:jn2, :jn3)
    root.edges << new_edge(:jn3, :E1 )

    self[:jn1].tap do |jn1|
      jn1.children << new_start
      jn1.children << new_ruby_job("j11"){ puts "j11" }
      jn1.children << new_script("j12", script: "job_test j12")
      jn1.children << new_ruby_job("j13"){ puts "j13" }
      jn1.children << new_end
      jn1.edges << new_edge(:S2 , :j11)
      jn1.edges << new_edge(:j11, :j12)
      jn1.edges << new_edge(:j12, :j13)
      jn1.edges << new_edge(:j13, :E2 )
    end

    self[:jn2].tap do |jn2|
      jn2.children << new_start
      jn2.children << new_script("j21", script: "job_test j21")
      jn2.children << new_script("j22", script: "job_test j22")
      jn2.children << new_ruby_job("j23"){ puts "j23" }
      jn2.children << new_end
      jn2.edges << new_edge(:S3 , :j21)
      jn2.edges << new_edge(:j21, :j22)
      jn2.edges << new_edge(:j22, :j23)
      jn2.edges << new_edge(:j23, :E3 )
    end

    self[:jn3].tap do |jn3|
      jn3.children << new_start
      jn3.children << new_ruby_job("j31"){ puts "j31" }
      jn3.children << new_script("j32", script: "job_test j32")
      jn3.children << new_ruby_job("j33"){ puts "j33" }
      jn3.children << new_end
      jn3.edges << new_edge(:S3 , :j31)
      jn3.edges << new_edge(:j31, :j32)
      jn3.edges << new_edge(:j32, :j33)
      jn3.edges << new_edge(:j33, :E3 )
    end

    root.save!
    Tengine::Job::DslLoader.update_loaded_blocks(root)
    root
  end
end
