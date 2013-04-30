# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0012]
# (S1)--e1-->[j1000]--e2-->[j2000]--e3-->(E1)
#
# in [j1000]
# (S2)--e4-->[j1100]--e5-->[j1200]--e6-->(E2)
#
# in [j1100]
# (S3)--e7-->(j1110)--e8-->(E3)
#
# in [j1200]
# (S4)--e9-->(j1210)--e10-->(E4)
#
# in [j1000:finally (=j1f00)]
# (S5)--e11-->[j1f10]--e12-->(E5)
#
# in [j1f10]
# (S6)--e13-->(j1f11)--e14-->(E6)
#
# in [j1000:finally:finally (=j1ff0)]
# (S7)--e15-->(j1ff1)--e16-->(E7)
#
# in [j2000]
# (S8)--e17-->(j2100)--e18-->(E8)
#
# in [jf000:finally (=jf000)]
# (S9)--e19-->(jf100)--e20-->(E9)
#

class Rjn0012NestedAndFinallyBuilder < JobnetFixtureBuilder
  DSL = <<-EOS
    jobnet("rjn0012") do
      auto_sequence
      jobnet("j1000") do
        jobnet("j1100") do
          job("j1110", "job_test j1110")
        end
        jobnet("j1200") do
          job("j1210", "job_test j1210")
        end
        finally do
          jobnet("j1f10") do
            job("j1f11", "job_test j1f11")
          end
          finally do
            job("j1ff1", "job_test j1ff1")
          end
        end
      end

      jobnet("j2000") do
        job("j2100", "job_test j2100")
      end

      finally do
        job("jf100", "job_test jf100")
      end
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0012")
    root.children << new_start
    root.children << new_jobnet("j1000")
    root.children << new_jobnet("j2000")
    root.children << new_finally
    root.children << new_end
    root.edges << new_edge(:S1   , :j1000)
    root.edges << new_edge(:j1000, :j2000)
    root.edges << new_edge(:j2000, :E1  )

    self[:j1000].tap do |j1000|
      j1000.children << new_start
      j1000.children << new_jobnet("j1100")
      j1000.children << new_jobnet("j1200")
      j1000.children << new_finally
      j1000.children << new_end
      j1000.edges << new_edge(:S2   , :j1100)
      j1000.edges << new_edge(:j1100, :j1200)
      j1000.edges << new_edge(:j1200, :E2   )

      self[:j1100].tap do |j1100|
        j1100.children << new_start
        j1100.children << new_script("j1110", :script => "job_test j1110")
        j1100.children << new_end
        j1100.edges << new_edge(:S3   , :j1110)
        j1100.edges << new_edge(:j1110, :E3   )
      end
      self[:j1200].tap do |j1200|
        j1200.children << new_start
        j1200.children << new_script("j1210", :script => "job_test j1210")
        j1200.children << new_end
        j1200.edges << new_edge(:S4   , :j1210)
        j1200.edges << new_edge(:j1210, :E4   )
      end

      self[:j1f00] = j1000.finally_vertex
      self[:j1f00].tap do |j1f00|
        j1f00.children << new_start
        j1f00.children << new_jobnet("j1f10")
        j1f00.children << new_finally
        j1f00.children << new_end
        j1f00.edges << new_edge(:S5   , :j1f10)
        j1f00.edges << new_edge(:j1f10, :E5   )
        self[:j1f10].tap do |j1f10|
          j1f10.children << new_start
          j1f10.children << new_script("j1f11", :script => "job_test j1f11")
          j1f10.children << new_end
          j1f10.edges << new_edge(:S6   , :j1f11)
          j1f10.edges << new_edge(:j1f11, :E6   )
        end
        self[:j1ff0] = j1f00.finally_vertex
        self[:j1ff0].tap do |j1ff0|
          j1ff0.children << new_start
          j1ff0.children << new_script("j1ff1")
          j1ff0.children << new_end
          j1ff0.edges << new_edge(:S7   , :j1ff1)
          j1ff0.edges << new_edge(:j1ff1, :E7   )
        end
      end
    end

    self[:j2000].tap do |j2000|
      j2000.children << new_start
      j2000.children << new_script("j2100", :script => "job_test j2100")
      j2000.children << new_end
      j2000.edges << new_edge(:S8   , :j2100)
      j2000.edges << new_edge(:j2100, :E8   )
    end

    self[:jf000] = root.finally_vertex
    self[:jf000].tap do |jf000|
      jf000.children << new_start
      jf000.children << new_script("jf100")
      jf000.children << new_end
      jf000.edges << new_edge(:S9   , :jf100)
      jf000.edges << new_edge(:jf100, :E9   )
    end

    unless root.valid?
      v = Tengine::Job::Structure::Visitor::AllWithEdge.new do |obj|
        if obj.respond_to?(:errors) && !obj.errors.empty?
          puts obj.errors.inspect
          true
        end
      end
      root.accept_visitor(v)
    end

    root.save!

    root
  end
end
