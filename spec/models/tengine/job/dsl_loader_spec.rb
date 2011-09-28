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
    context do
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
  end

end
