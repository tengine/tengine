# -*- coding: utf-8 -*-

require File.expand_path('test_credential_fixture', File.dirname(__FILE__))
require File.expand_path('test_server_fixture', File.dirname(__FILE__))

# 以下のジョブネットについてテンプレートジョブネットや
# 実行用ジョブネットを扱うフィクスチャ生成のためのクラスです。
#
# [rjn1004]
# (S1)--e1-->(job1)--e2-->[hadoop_job_run1]--e3-->(job2)--e4-->(E1)
#
# [hadoop_job_run1]
# (S2)--e5-->[hadoop_job1]--e6-->[hadoop_job2]--e7-->(E2)
#
# [hadoop_job1]
#              |--e9--->(Map)------e11-->|
# (S3)--e8-->[F1]                      [J1]--e13-->(E3)
#              |--e10-->(Reduce) --e12-->|
#
# [hadoop_job2]
#               |--e15-->(Map)------e17-->|
# (S4)--e14-->[F2]                      [J2]--e19-->(E4)
#               |--e16-->(Reduce) --e18-->|

class Rjn1004HadoopJobInJobnetFixture < JobnetFixtureBuilder
  include TestCredentialFixture
  include TestServerFixture

  DSL = <<-EOS
    require 'tengine_job'

    jobnet("jobnet1004", :instance_name => "test_server1", :credential_name => "test_credential1") do
      auto_sequence
      job("job1", "$HOME/import_hdfs.sh")
      hadoop_job_run("hadoop_job_run1", "Hadoopジョブ1", "$HOME/hadoop_job_run.sh") do
        hadoop_job("hadoop_job1")
        hadoop_job("hadoop_job2")
      end
      job("job2", "$HOME/export_hdfs.sh")
    end
  EOS

  def create(options = {})
    root = new_root_jobnet("rjn1004", {
        :server_name => test_server1.name, 
        :credential_name => test_credential1.name
      }.update(options || { }))
    root.children << new_start
    root.children << new_script("job1", :script => "$HOME/import_hdfs.sh")
    root.children << new_jobnet("hadoop_job_run1", :jobnet_type_key => :hadoop_job_run,
      :description => "Hadoopジョブ1", :script => "$HOME/hadoop_job_run.sh")
    root.children << new_script("job2", :script => "$HOME/export_hdfs.sh")
    root.children << new_end
    root.build_sequencial_edges
    self[:e1] = root.edges[0]
    self[:e2] = root.edges[1]
    self[:e3] = root.edges[2]
    self[:e4] = root.edges[3]

    self[:hadoop_job_run1].tap do |hadoop_job_run1|
      hadoop_job_run1.children << new_start
      hadoop_job_run1.children << new_jobnet("hadoop_job1", :jobnet_type_key => :hadoop_job)
      hadoop_job_run1.children << new_jobnet("hadoop_job2", :jobnet_type_key => :hadoop_job)
      hadoop_job_run1.children << new_end
      hadoop_job_run1.build_sequencial_edges
      self[:e5] = hadoop_job_run1.edges[0]
      self[:e6] = hadoop_job_run1.edges[1]
      self[:e7] = hadoop_job_run1.edges[2]


      self[:hadoop_job1].tap do |hadoop_job1|
        hadoop_job1.children << new_start
        hadoop_job1.children << new_fork
        hadoop_job1.children << new_jobnet("Map", :jobnet_type_key => :map_phase)
        hadoop_job1.children << new_jobnet("Reduce", :jobnet_type_key => :reduce_phase)
        hadoop_job1.children << new_join
        hadoop_job1.children << new_end
        hadoop_job1.edges << new_edge(:S3, :F1)
        hadoop_job1.edges << new_edge(:F1, :Map   )
        hadoop_job1.edges << new_edge(:F1, :Reduce)
        hadoop_job1.edges << new_edge(:Map   , :J1)
        hadoop_job1.edges << new_edge(:Reduce, :J1)
        hadoop_job1.edges << new_edge(:J1, :E3)
      end

      self[:hadoop_job2].tap do |hadoop_job1|
        hadoop_job1.children << new_start
        hadoop_job1.children << new_fork
        hadoop_job1.children << new_jobnet("Map", :jobnet_type_key => :map_phase)
        hadoop_job1.children << new_jobnet("Reduce", :jobnet_type_key => :reduce_phase)
        hadoop_job1.children << new_join
        hadoop_job1.children << new_end
        hadoop_job1.edges << new_edge(:S4, :F2)
        hadoop_job1.edges << new_edge(:F2, :Map   )
        hadoop_job1.edges << new_edge(:F2, :Reduce)
        hadoop_job1.edges << new_edge(:Map   , :J2)
        hadoop_job1.edges << new_edge(:Reduce, :J2)
        hadoop_job1.edges << new_edge(:J2, :E4)
      end
    end

    root.save!
    root
  end
end
