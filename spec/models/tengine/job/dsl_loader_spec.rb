# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::DslLoader do
  before do
    Tengine.dsl_loader_modules << Tengine::Job::DslLoader
  end

  after do
    Tengine.dsl_loader_modules.delete(Tengine::Job::DslLoader)
  end

  def load_dsl(filename)
    config = {
      :action => "load",
      :tengined => { :load_path => File.expand_path("dsls/#{filename}", File.dirname(__FILE__)) },
    }
    @bootstrap = Tengine::Core::Bootstrap.new(config)
    @bootstrap.boot
  end

  describe "基本的なジョブDSL" do
    context "0001_hadoop_job_run.rb" do
      before{
        Tengine::Job::JobnetTemplate.delete_all
        load_dsl("0001_hadoop_job_run.rb")
      }

      it do
        root_jobnet = Tengine::Job::JobnetTemplate.by_name("jobnet0001")
        root_jobnet.should be_a(Tengine::Job::JobnetTemplate)
        root_jobnet.tap do |j|
          j.name.should == "jobnet0001"
          j.description.should == "ジョブネット0001"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::JobnetTemplate,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::End,
        ]
        root_jobnet.children[1].tap{|j| j.name.should == "job1"; j.description.should == "ジョブ1"; j.script.should == "import_hdfs.sh"}
        hadoop_job_run = root_jobnet.children[2]
        root_jobnet.children[3].tap{|j| j.name.should == "job2"; j.description.should == "ジョブ2"; j.script.should == "export_hdfs.sh"}
        root_jobnet.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [root_jobnet.children[0], root_jobnet.children[1]],
          [root_jobnet.children[1], root_jobnet.children[2]],
          [root_jobnet.children[2], root_jobnet.children[3]],
          [root_jobnet.children[3], root_jobnet.children[4]],
        ]
        hadoop_job_run.tap{|j| j.name.should == "hadoop_job_run1"; j.description.should == "Hadoopジョブ1"; j.script.should == "hadoop_job_run.sh"}
        hadoop_job_run.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::JobnetTemplate,
          Tengine::Job::JobnetTemplate,
          Tengine::Job::End,
        ]
        hadoop_job_run.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [hadoop_job_run.children[0], hadoop_job_run.children[1]],
          [hadoop_job_run.children[1], hadoop_job_run.children[2]],
          [hadoop_job_run.children[2], hadoop_job_run.children[3]],
        ]
        hadoop_job1 = hadoop_job_run.children[1]
        hadoop_job1.tap{|j| j.name.should == "hadoop_job1"}
        hadoop_job1.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::Fork,
          Tengine::Job::Job,
          Tengine::Job::Job,
          Tengine::Job::Join,
          Tengine::Job::End,
        ]

        hadoop_job1.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [hadoop_job1.children[0], hadoop_job1.children[1]],
          [hadoop_job1.children[1], hadoop_job1.children[2]],
          [hadoop_job1.children[1], hadoop_job1.children[3]],
          [hadoop_job1.children[2], hadoop_job1.children[4]],
          [hadoop_job1.children[3], hadoop_job1.children[4]],
          [hadoop_job1.children[4], hadoop_job1.children[5]],
        ]

        hadoop_job1.edges.map{|edge| [edge.origin.class, edge.destination.class]}.should == [
          [Tengine::Job::Start, Tengine::Job::Fork],
          [Tengine::Job::Fork , Tengine::Job::Job ],
          [Tengine::Job::Fork , Tengine::Job::Job ],
          [Tengine::Job::Job  , Tengine::Job::Join],
          [Tengine::Job::Job  , Tengine::Job::Join],
          [Tengine::Job::Join , Tengine::Job::End ],
        ]
        hadoop_job2 = hadoop_job_run.children[2]
        hadoop_job2.tap{|j| j.name.should == "hadoop_job2"}
        hadoop_job2.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::Fork,
          Tengine::Job::Job,
          Tengine::Job::Job,
          Tengine::Job::Join,
          Tengine::Job::End,
        ]
      end
    end

    context "0002_join_and_join.rb" do
      before{
        Tengine::Job::JobnetTemplate.delete_all
        load_dsl("0002_join_and_join.rb")
      }

      it do
        root_jobnet = Tengine::Job::JobnetTemplate.by_name("jobnet0002")
        root_jobnet.should be_a(Tengine::Job::JobnetTemplate)
        root_jobnet.tap do |j|
          j.name.should == "jobnet0002"
          j.description.should == "jobnet0002"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Start         , # 0
          Tengine::Job::ScriptTemplate, # 1
          Tengine::Job::ScriptTemplate, # 2
          Tengine::Job::ScriptTemplate, # 3
          Tengine::Job::ScriptTemplate, # 4
          Tengine::Job::ScriptTemplate, # 5
          Tengine::Job::Fork          , # 6
          Tengine::Job::Join          , # 7
          Tengine::Job::Join          , # 8
          Tengine::Job::End           , # 9
        ]
        root_jobnet.children[1].tap{|j| j.name.should == "job1"; j.description.should == "job1"; j.script.should == "echo 'job1'"}
        root_jobnet.children[2].tap{|j| j.name.should == "job2"; j.description.should == "job2"; j.script.should == "echo 'job2'"}
        root_jobnet.children[3].tap{|j| j.name.should == "job3"; j.description.should == "job3"; j.script.should == "echo 'job3'"}
        root_jobnet.children[4].tap{|j| j.name.should == "job4"; j.description.should == "job4"; j.script.should == "echo 'job4'"}
        root_jobnet.children[5].tap{|j| j.name.should == "job5"; j.description.should == "job5"; j.script.should == "echo 'job5'"}

        root_jobnet.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [root_jobnet.children[0], root_jobnet.children[6]],
          [root_jobnet.children[6], root_jobnet.children[1]],
          [root_jobnet.children[6], root_jobnet.children[2]],
          [root_jobnet.children[6], root_jobnet.children[3]],
          [root_jobnet.children[1], root_jobnet.children[7]],
          [root_jobnet.children[2], root_jobnet.children[7]],
          [root_jobnet.children[7], root_jobnet.children[4]],
          [root_jobnet.children[3], root_jobnet.children[8]],
          [root_jobnet.children[4], root_jobnet.children[8]],
          [root_jobnet.children[8], root_jobnet.children[5]],
          [root_jobnet.children[5], root_jobnet.children[9]],
        ]
      end
    end

    context "0003_fork_and_fork.rb" do
      before{
        Tengine::Job::JobnetTemplate.delete_all
        load_dsl("0003_fork_and_fork.rb")
      }

      it do
        root_jobnet = Tengine::Job::JobnetTemplate.by_name("jobnet0003")
        root_jobnet.should be_a(Tengine::Job::JobnetTemplate)
        root_jobnet.tap do |j|
          j.name.should == "jobnet0003"
          j.description.should == "jobnet0003"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Start         , # 0
          Tengine::Job::ScriptTemplate, # 1
          Tengine::Job::ScriptTemplate, # 2
          Tengine::Job::ScriptTemplate, # 3
          Tengine::Job::ScriptTemplate, # 4
          Tengine::Job::ScriptTemplate, # 5
          Tengine::Job::Fork          , # 6
          Tengine::Job::Fork          , # 7
          Tengine::Job::Join          , # 8
          Tengine::Job::End           , # 9
        ]
        root_jobnet.children[1].tap{|j| j.name.should == "job1"; j.description.should == "job1"; j.script.should == "echo 'job1'"}
        root_jobnet.children[2].tap{|j| j.name.should == "job2"; j.description.should == "job2"; j.script.should == "echo 'job2'"}
        root_jobnet.children[3].tap{|j| j.name.should == "job3"; j.description.should == "job3"; j.script.should == "echo 'job3'"}
        root_jobnet.children[4].tap{|j| j.name.should == "job4"; j.description.should == "job4"; j.script.should == "echo 'job4'"}
        root_jobnet.children[5].tap{|j| j.name.should == "job5"; j.description.should == "job5"; j.script.should == "echo 'job5'"}

        root_jobnet.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [root_jobnet.children[0], root_jobnet.children[1]],
          [root_jobnet.children[1], root_jobnet.children[6]],
          [root_jobnet.children[6], root_jobnet.children[2]],
          [root_jobnet.children[6], root_jobnet.children[3]],
          [root_jobnet.children[3], root_jobnet.children[7]],
          [root_jobnet.children[7], root_jobnet.children[4]],
          [root_jobnet.children[7], root_jobnet.children[5]],
          [root_jobnet.children[2], root_jobnet.children[8]],
          [root_jobnet.children[4], root_jobnet.children[8]],
          [root_jobnet.children[5], root_jobnet.children[8]],
          [root_jobnet.children[8], root_jobnet.children[9]],
        ]
      end
    end

  end

end
