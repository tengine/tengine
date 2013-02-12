# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0002]
#                         |--e3-->(j2)--e5-->|
# (S1)--e1-->(j1)--e2-->[F1]               [J1]--e7-->(j4)--e8-->(E1)
#                         |--e4-->(j3)--e6-->|

class Rjn0022RubyJobFixture < JobnetFixtureBuilder

  DSL = <<-EOS
    jobnet("rjn0022") do
      boot_jobs('j1')
      ruby_job('j1', :to => ['j2', 'j3']){ STDOUT.puts("j1") }
      ruby_job('j2', :to => 'j4'        ){ STDOUT.puts("j2") }
      ruby_job('j3', :to => 'j4'        ){ STDOUT.puts("j3") }
      ruby_job('j4'                     ){ STDOUT.puts("j4") }
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0002", options)
    root.children << new_start
    root.children << new_ruby_job("j1"){ STDOUT.puts("j1") }
    root.children << new_fork
    root.children << new_ruby_job("j2"){ STDOUT.puts("j2") }
    root.children << new_ruby_job("j3"){ STDOUT.puts("j3") }
    root.children << new_join
    root.children << new_ruby_job("j4"){ STDOUT.puts("j4") }
    root.children << new_end
    root.edges << new_edge(:S1, :j1)
    root.edges << new_edge(:j1, :F1)
    root.edges << new_edge(:F1, :j2)
    root.edges << new_edge(:F1, :j3)
    root.edges << new_edge(:j2, :J1)
    root.edges << new_edge(:j3, :J1)
    root.edges << new_edge(:J1, :j4)
    root.edges << new_edge(:j4, :E1)
    root.save!
    Tengine::Job::DslLoader.update_loaded_blocks(root)
    root
  end
end
