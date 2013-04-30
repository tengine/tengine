# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0008]
# (S1) --e1-->(rjn0001)--e2-->(rjn0002)--e3-->(E1)

class Rjn0008ExpansionFixture < JobnetFixtureBuilder
  DSL = <<-EOS
    jobnet("rjn0008") do
      auto_sequence
      expansion("rjn0001")
      expansion("rjn0002")
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0008", options)
    root.children << new_start
    root.children << new_expansion("rjn0001")
    root.children << new_expansion("rjn0002")
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
