# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0010]
#              |-----e2----->(j11)-----e4----->|
# [S1]--e1-->[F1]                            [J1]--e7-->[E1]
#              |--e3-->(j12)--e5-->(j13)--e6-->|

class Rjn00102jobsAnd1jobParallelJobnetBuilder < JobnetFixtureBuilder
  DSL = <<-EOS
    jobnet("rjn0010") do
      boot_jobs("j11", "j12")
      job("j11", "job_test j11")
      job("j12", "job_test j12", :to => "j13")
      job("j13", "job_test j13")
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0010")
    root.children << new_start
    root.children << new_fork
    root.children << new_script("j11", :script => "job_test j11")
    root.children << new_script("j12", :script => "job_test j12")
    root.children << new_script("j13", :script => "job_test j13")
    root.children << new_join
    root.children << new_end
    root.edges << new_edge(:S1, :F1)
    root.edges << new_edge(:F1, :j11)
    root.edges << new_edge(:F1, :j12)
    root.edges << new_edge(:j11, :J1)
    root.edges << new_edge(:j12, :j13)
    root.edges << new_edge(:j13, :J1)
    root.edges << new_edge(:J1, :E1)
    root.save!
    root
  end
end
