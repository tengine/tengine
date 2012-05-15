# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0003]
#                                                |--e7-->(j14)--e11-->(j16)--e14--->|
#              |--e2-->(j11)--e4-->(j13)--e6-->[F2]                                 |
# (S1)--e1-->[F1]                                |--e8-->[J1]--e12-->(j17)--e15-->[J2]--e16-->(E2)
#              |                                 |--e9-->[J1]                       |
#              |--e3-->(j12)------e5---------->[F3]                                 |
#                                                |--e10---->(j15)---e13------------>|
class Rjn0003ForkJoinJobnetBuilder < JobnetFixtureBuilder
  DSL = <<-EOS
    jobnet("rjn0003") do
      boot_jobs("j11", "j12")
      job("j11", "job_test j11", :to => "j13")
      job("j12", "job_test j12", :to => ["j15", "j17"])
      job("j13", "job_test j13", :to => ["j14", "j17"])
      job("j14", "job_test j14", :to => "j16")
      job("j15", "job_test j15")
      job("j16", "job_test j16")
      job("j17", "job_test j17")
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0003")
    root.children << new_start
    root.children << new_fork # F1
    root.children << new_script("j11", :script => "job_test j11")
    root.children << new_script("j12", :script => "job_test j12")
    root.children << new_script("j13", :script => "job_test j13")
    root.children << new_fork # F2
    root.children << new_fork # F3
    root.children << new_join # J1
    root.children << new_script("j14", :script => "job_test j14")
    root.children << new_script("j15", :script => "job_test j15")
    root.children << new_script("j16", :script => "job_test j16")
    root.children << new_script("j17", :script => "job_test j17")
    root.children << new_join # J2
    root.children << new_end
    root.edges << new_edge(:S1 , :F1 ) # e1
    root.edges << new_edge(:F1 , :j11) # e2
    root.edges << new_edge(:F1 , :j12) # e3
    root.edges << new_edge(:j11, :j13) # e4
    root.edges << new_edge(:j12, :F3 ) # e5
    root.edges << new_edge(:j13, :F2 ) # e6
    root.edges << new_edge(:F2 , :j14) # e7
    root.edges << new_edge(:F2 , :J1 ) # e8
    root.edges << new_edge(:F3 , :J1 ) # e9
    root.edges << new_edge(:F3 , :j15) # e10
    root.edges << new_edge(:j14, :j16) # e11
    root.edges << new_edge(:J1 , :j17) # e12
    root.edges << new_edge(:j15 ,:J2 ) # e13
    root.edges << new_edge(:j16 ,:J2 ) # e14
    root.edges << new_edge(:j17 ,:J2 ) # e15
    root.edges << new_edge(:J2 , :E1 ) # e16
    root.save!
    root
  end
end
