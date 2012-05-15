# -*- coding: utf-8 -*-

require File.expand_path('test_credential_fixture', File.dirname(__FILE__))
require File.expand_path('test_server_fixture', File.dirname(__FILE__))

# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# in [jn0005]
#                         |--e3-->(j2)--e5--->|
# (S1)--e1-->(j1)--e2-->[F1]                [J1]-->e7-->(j4)--e8-->(E1)
#                         |--e4-->[jn4]--e6-->|
#
# in [jn0005/jn4]
#                          |--e11-->(j42)--e13-->|
# (S2)--e9-->(j41)--e10-->[F2]                  [J2]--e15-->(j44)--e16-->(E2)
#                          |--e12-->(j43)--e14-->|
#
# in [jn0005/jn4/finally]
# (S3)--e17-->(jn4_f)--e18-->(E3)
#
# in [jn0005/finally]
# (S4)--e19-->[jn0005_fjn]--e20-->(jn0005_f)--e21-->(E4)
#
# in [jn0005/finally/jn0005_fjn]
# (S5)--e22-->(jn0005_f1)--e23-->(jn0005_f1)--e24-->(E5)
#
# in [jn0005/finally/jn0005_fjn/finally]
# (S6)--e25-->(jn0005_fif)--e26-->(E6)

class Rjn0005RetryTwoLayerFixture < JobnetFixtureBuilder
  include TestCredentialFixture
  include TestServerFixture

  DSL = <<-EOS
    jobnet("jn0005", :instance_name => "test_server1", :credential_name => "test_credential1") do
      boot_jobs("j1")
      job("j1", "$HOME/0005_retry_two_layer.sh", :to => ["j2", "jn4"])
      job("j2", "$HOME/0005_retry_two_layer.sh", :to => "j4")
      jobnet("jn4", :to => "j4") do
        boot_jobs("j41")
        job("j41", "$HOME/0005_retry_two_layer.sh", :to => ["j42", "j43"])
        job("j42", "$HOME/0005_retry_two_layer.sh", :to => "j44")
        job("j43", "$HOME/0005_retry_two_layer.sh", :to => "j44")
        job("j44", "$HOME/0005_retry_two_layer.sh")
        finally do
          job("jn4_f", "$HOME/0005_retry_two_layer.sh")
        end
      end
      job("j4", "$HOME/0005_retry_two_layer.sh")
      finally do
        boot_jobs("jn0005_fjn")
        jobnet("jn0005_fjn", :to => "jn0005_f") do
          boot_jobs("jn0005_f1")
          job("jn0005_f1", "$HOME/0005_retry_two_layer.sh", :to => ["jn0005_f2"])
          job("jn0005_f2", "$HOME/0005_retry_two_layer.sh")
          finally do
            job("jn0005_fif","$HOME/0005_retry_two_layer.sh")
          end 
        end
        job("jn0005_f", "$HOME/0005_retry_two_layer.sh")
      end
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("jn0005", {
        :server_name => test_server1.name, 
        :credential_name => test_credential1.name
      }.update(options || { }))
    # root
    root.children << new_start
    root.children << new_script("j1", :script => "$HOME/0005_retry_two_layer.sh")
    root.children << new_fork
    root.children << new_script("j2", :script => "$HOME/0005_retry_two_layer.sh")
    root.children << new_jobnet("jn4")
    root.children << new_join
    root.children << new_script("j4", :script => "$HOME/0005_retry_two_layer.sh")
    root.children << new_finally
    root.children << new_end
    root.edges << new_edge(:S1, :j1)
    root.edges << new_edge(:j1, :F1)
    root.edges << new_edge(:F1, :j2)
    root.edges << new_edge(:F1, :jn4)
    root.edges << new_edge(:j2, :J1)
    root.edges << new_edge(:jn4, :J1)
    root.edges << new_edge(:J1, :j4)
    root.edges << new_edge(:j4, :E1)

    self[:jn4].tap do |jn4|
      jn4.children << new_start
      jn4.children << new_script("j41", :script => "$HOME/0005_retry_two_layer.sh")
      jn4.children << new_fork
      jn4.children << new_script("j42", :script => "$HOME/0005_retry_two_layer.sh")
      jn4.children << new_script("j43", :script => "$HOME/0005_retry_two_layer.sh")
      jn4.children << new_join
      jn4.children << new_script("j44", :script => "$HOME/0005_retry_two_layer.sh")
      jn4.children << new_finally
      jn4.children << new_end
      jn4.edges << new_edge(:S2, :j41)
      jn4.edges << new_edge(:j41, :F2)
      jn4.edges << new_edge(:F2, :j42)
      jn4.edges << new_edge(:F2, :j43)
      jn4.edges << new_edge(:j42, :J2)
      jn4.edges << new_edge(:j43, :J2)
      jn4.edges << new_edge(:J2, :j44)
      jn4.edges << new_edge(:j44, :E2)

      self[:jn4f] = jn4.finally_vertex
      self[:jn4f].tap do |jn4f|
        jn4f.children << new_start
        jn4f.children << new_script("jn4_f", :script => "$HOME/0005_retry_two_layer.sh")
        jn4f.children << new_end
        jn4f.edges << new_edge(:S3, :jn4_f)
        jn4f.edges << new_edge(:jn4_f, :E3)
      end
    end

    self[:finally] = root.finally_vertex
    self[:finally].tap do |finally|
      finally.children << new_start
      finally.children << new_jobnet("jn0005_fjn")
      finally.children << new_script("jn0005_f", :script => "$HOME/0005_retry_two_layer.sh")
      finally.children << new_end
      finally.edges << new_edge(:S4, :jn0005_fjn)
      finally.edges << new_edge(:jn0005_fjn, :jn0005_f)
      finally.edges << new_edge(:jn0005_f, :E4)

      self[:jn0005_fjn].tap do |jn0005_fjn|
        jn0005_fjn.children << new_start
        jn0005_fjn.children << new_script("jn0005_f1", :script => "$HOME/0005_retry_two_layer.sh")
        jn0005_fjn.children << new_script("jn0005_f2", :script => "$HOME/0005_retry_two_layer.sh")
        jn0005_fjn.children << new_finally
        jn0005_fjn.children << new_end
        jn0005_fjn.edges << new_edge(:S5, :jn0005_f1)
        jn0005_fjn.edges << new_edge(:jn0005_f1, :jn0005_f2)
        jn0005_fjn.edges << new_edge(:jn0005_f2, :E5)

        self[:jn0005_fjn_f] = jn0005_fjn.finally_vertex
        self[:jn0005_fjn_f].tap do |jn0005_fjn_f|
          jn0005_fjn_f.children << new_start
          jn0005_fjn_f.children << new_script("jn0005_fif", :script => "$HOME/0005_retry_two_layer.sh")
          jn0005_fjn_f.children << new_end
          jn0005_fjn_f.edges << new_edge(:S6, :jn0005_fif)
          jn0005_fjn_f.edges << new_edge(:jn0005_fif, :E6)
        end
      end
    end

    root.save!
    root
  end
end
