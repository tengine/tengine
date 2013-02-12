# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0002]
#                         |--e3-->(j2)--e5-->|
# (S1)--e1-->(j1)--e2-->[F1]               [J1]--e7-->(j4)--e8-->(E1)
#                         |--e4-->(j3)--e6-->|

class Rjn0024ExplicitSucceedAndFailFixture < JobnetFixtureBuilder

  DSL = <<-EOS
    jobnet("rjn0024") do
      boot_jobs(*%w[jn01 jn02 j10 j11 j12])

      jobnet("jn01") do
        boot_jobs(*%w[j01 j02 j03 j04 j05 j06])
        ruby_job('j01'){|job| STDOUT.puts("j01 end") } # 自動でjob.succeedされる
        ruby_job('j02'){|job| job.succeed(:message => "j02 success"); STDOUT.puts("j02 end") }
        ruby_job('j03'){|job| job.fail(:exception => RuntimeError.new("j03 raise exception")); STDOUT.puts("j03 end") }
        ruby_job('j04'){|job| job.fail(:message => "j04 failed"); STDOUT.puts("j04 end") }
        ruby_job('j05'){|job| job.fail; job.succeed; job.fail; STDOUT.puts("j05 end") } # 最後のjob.failによってerrorになる
        ruby_job('j06'){|job| job.succeed; job.fail; job.succeed; STDOUT.puts("j06 end") } # 最後のjob.succeedによってsuccessになる
      end

      # job.succeedを明示的に書いていないけど必要に応じて呼び出される
      conductor1 = lambda{|job| job.run}
      jobnet('jn02', :conductors => {:ruby_job => conductor1}) do
        boot_jobs(*%w[j07 j08 j09])
        ruby_job('j07'){|job| STDOUT.puts("j07 end") } # 自動でjob.succeedされる
        ruby_job('j08'){|job| job.succeed(:message => "j08 success") }
        ruby_job('j09'){|job| job.fail(:message => "j09 failed") }
      end

      # job.runが2回記述されているけど一度しか動かさない
      ruby_job('j10', :conductor => lambda{|job| job.run; job.run}){|job| STDOUT.puts("j10 end") }

      # conductorではjob.succeed の後に job.fail を実行するとsuccessに。
      ruby_job('j11', :conductor => lambda{|job| job.run; job.succeed; job.fail}){|job| STDOUT.puts("j11 end") }

      # conductorではjob.fail の後に job.succeed を実行するとerrorに。
      ruby_job('j12', :conductor => lambda{|job| job.run; job.fail; job.succeed}){|job| STDOUT.puts("j12 end") }
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0024", options)
    root.children << new_start
    root.children << new_fork
    root.children << new_jobnet("jn01")
    root.children << new_jobnet("jn02", :conductors => {:ruby_job => lambda{|job| job.run}})
    root.children << new_ruby_job('j10', :conductor => lambda{|job| job.run; job.run}){|job| STDOUT.puts("j10 end") }
    root.children << new_ruby_job('j11', :conductor => lambda{|job| job.run; job.succeed; job.fail}){|job| STDOUT.puts("j11 end") }
    root.children << new_ruby_job('j12', :conductor => lambda{|job| job.run; job.fail; job.succeed}){|job| STDOUT.puts("j12 end") }
    root.children << new_join
    root.children << new_end

    root.edges << new_edge(:S1, :F1  )
    root.edges << new_edge(:F1, :jn01)
    root.edges << new_edge(:F1, :jn02)
    root.edges << new_edge(:F1, :j10 )
    root.edges << new_edge(:F1, :j11 )
    root.edges << new_edge(:F1, :j12 )
    root.edges << new_edge(:jn01,:J1 )
    root.edges << new_edge(:jn02,:J1 )
    root.edges << new_edge(:j10 ,:J1 )
    root.edges << new_edge(:j11 ,:J1 )
    root.edges << new_edge(:j12 ,:J1 )
    root.edges << new_edge(:J1, :E1  )

    self[:jn01].tap do |jn01|
      jn01.children << new_start
      jn01.children << new_fork
      jn01.children << new_ruby_job('j01'){|job| STDOUT.puts("j01 end") } # 自動でjob.succeedされる
      jn01.children << new_ruby_job('j02'){|job| job.succeed(:message => "j02 success"); STDOUT.puts("j02 end") }
      jn01.children << new_ruby_job('j03'){|job| job.fail(:exception => RuntimeError.new("j03 raise exception")); STDOUT.puts("j03 end") }
      jn01.children << new_ruby_job('j04'){|job| job.fail(:message => "j04 failed"); STDOUT.puts("j04 end") }
      jn01.children << new_ruby_job('j05'){|job| job.fail; job.succeed; job.fail; STDOUT.puts("j05 end") } # 最後のjob.failによってerrorになる
      jn01.children << new_ruby_job('j06'){|job| job.succeed; job.fail; job.succeed; STDOUT.puts("j06 end") } # 最後のjob.succeedによってsuccessになる
      jn01.children << new_join
      jn01.children << new_end

      jn01.edges << new_edge(:S2 , :F2 )
      jn01.edges << new_edge(:F2 , :j01)
      jn01.edges << new_edge(:F2 , :j02)
      jn01.edges << new_edge(:F2 , :j03)
      jn01.edges << new_edge(:F2 , :j04)
      jn01.edges << new_edge(:F2 , :j05)
      jn01.edges << new_edge(:F2 , :j06)
      jn01.edges << new_edge(:j01, :J2 )
      jn01.edges << new_edge(:j02, :J2 )
      jn01.edges << new_edge(:j03, :J2 )
      jn01.edges << new_edge(:j04, :J2 )
      jn01.edges << new_edge(:j05, :J2 )
      jn01.edges << new_edge(:j06, :J2 )
      jn01.edges << new_edge(:J2 , :E2 )
    end

    self[:jn02].tap do |jn02|
      jn02.children << new_start
      jn02.children << new_fork
      jn02.children << new_ruby_job('j07'){|job| STDOUT.puts("j07 end") } # 自動でjob.succeedされる
      jn02.children << new_ruby_job('j08'){|job| job.succeed(:message => "j08 success") }
      jn02.children << new_ruby_job('j09'){|job| job.fail(:message => "j09 failed") }
      jn02.children << new_join
      jn02.children << new_end
      jn02.edges << new_edge(:S3 , :F3 )
      jn02.edges << new_edge(:F3 , :j07)
      jn02.edges << new_edge(:F3 , :j08)
      jn02.edges << new_edge(:F3 , :j09)
      jn02.edges << new_edge(:j07, :J3 )
      jn02.edges << new_edge(:j08, :J3 )
      jn02.edges << new_edge(:j09, :J3 )
      jn02.edges << new_edge(:J3 , :E3 )
    end

    root.save!
    Tengine::Job::DslLoader.update_loaded_blocks(root)
    root
  end
end
