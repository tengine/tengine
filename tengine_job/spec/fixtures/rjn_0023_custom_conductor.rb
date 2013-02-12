# -*- coding: utf-8 -*-
# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [rjn0023]
# (S1)--e1-->(j1)--e2-->(E1)


module Rjn0023
  class << self
    attr_accessor :exception_class_name
    def raise_test_exception
      return unless exception_class_name
      raise exception_class_name.constantize.new("test exception")
    end
  end
end

class Rjn0023CustomConductor < JobnetFixtureBuilder

  CONDUCTOR1 = lambda do |job|
    begin
      job.run
    rescue SystemCallError, NoMemoryError, SecurityError => e
      raise # tenginedに例外処理を任せる
    rescue => e
      job.fail(:exception => e)
    else
      job.succeed
    end
  end

  DSL = <<-EOS
    # エラーとして扱う例外をカスタマイズ
    custom_conductor = lambda do |job|
      begin
        job.run
      rescue SystemCallError, NoMemoryError, SecurityError => e
        raise # tenginedに例外処理を任せる
      rescue => e
        job.fail(:exception => e)
      else
        job.succeed
      end
    end

    jobnet("rjn0023", :conductors => {:ruby_job => custom_conductor}) do
      ruby_job('j1'){ Rjn0023.raise_test_exception  }
      ruby_job('j2', :conductor => Tengine::Job::RubyJob::DEFAULT_CONDUCTOR){ Rjn0023.raise_test_exception  }
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn0023", {:conductors => {:ruby_job => CONDUCTOR1}}.update(options))
    root.children << new_start
    root.children << new_ruby_job("j1"){ Rjn0023.raise_test_exception }
    root.children << new_ruby_job("j2",
      :conductor => Tengine::Job::RubyJob::DEFAULT_CONDUCTOR){ Rjn0023.raise_test_exception }
    root.children << new_end
    root.edges << new_edge(:S1, :j1)
    root.edges << new_edge(:j1, :j2)
    root.edges << new_edge(:j2, :E1)
    root.save!
    Tengine::Job::DslLoader.update_loaded_blocks(root)
    root
  end
end
