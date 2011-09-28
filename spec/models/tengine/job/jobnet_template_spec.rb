# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::JobnetTemplate do

  describe "build_sequencial_edges" do
    context "普通の場合" do
      #                               |--- job111
      #             |--- jobnet11<>---|
      #             |                 |--- job112
      #             |
      # jobnet1<>---|
      #             |                 |--- job121
      #             |--- jobnet12<>---|
      #                               |--- job122
      #
      # 以下のように実行されるように
      # jobnet1
      # jobnet1/jobnet11
      # jobnet1/jobnet11/job111
      # jobnet1/jobnet11/job112
      # jobnet1/jobnet12
      # jobnet1/jobnet12/job121
      # jobnet1/jobnet12/job122
      it "レシーバ以下のジョブネットに対してシーケンシャルにedgesを構築する" do
        jobnet1 = Tengine::Job::JobnetTemplate.new(:name => "jobnet1")
        jobnet1 .children << jobnet11 = Tengine::Job::JobnetTemplate.new(:name => "jobnet11")
        jobnet11.children << job111   = Tengine::Job::ScriptTemplate.new(:name => "job111", :script => "job111.sh")
        jobnet11.children << job112   = Tengine::Job::ScriptTemplate.new(:name => "job112", :script => "job112.sh")
        jobnet1 .children << jobnet12 = Tengine::Job::JobnetTemplate.new(:name => "jobnet12")
        jobnet12.children << job121   = Tengine::Job::ScriptTemplate.new(:name => "job121", :script => "job121.sh")
        jobnet12.children << job122   = Tengine::Job::ScriptTemplate.new(:name => "job122", :script => "job122.sh")

        jobnet1.build_sequencial_edges
        jobnet1.save!

        jobnet1.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::JobnetTemplate,
          Tengine::Job::JobnetTemplate,
          Tengine::Job::End
        ]
        jobnet1.edges.map{|edge| [edge.origin_id, edge.destination_id]}.should == [
          [jobnet1.children.first.id, jobnet11.id],
          [jobnet11.id, jobnet12.id],
          [jobnet12.id, jobnet1.children.last.id],
        ]
        jobnet11.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::End
        ]
        jobnet11.edges.map{|edge| [edge.origin_id, edge.destination_id]}.should == [
          [jobnet11.children.first.id, job111.id],
          [job111.id, job112.id],
          [job112.id, jobnet11.children.last.id],
        ]
        jobnet12.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::End
        ]
        jobnet12.edges.map{|edge| [edge.origin_id, edge.destination_id]}.should == [
          [jobnet12.children.first.id, job121.id],
          [job121.id, job122.id],
          [job122.id, jobnet12.children.last.id],
        ]
      end
    end

    context "finally入りの場合" do
      #                               |--- job111
      #             |--- jobnet11<>---|
      #             |                 |--- job112
      #             |
      # jobnet1<>---|
      #             |                 |--- job121
      #             |--- finally<>---|
      #                               |--- job122
      #
      # 以下のように実行されるように
      # jobnet1
      # jobnet1/jobnet11
      # jobnet1/jobnet11/job111
      # jobnet1/jobnet11/job112
      # jobnet1/finally
      # jobnet1/finally/job121
      # jobnet1/finally/job122
      it "レシーバ以下のジョブネットに対してシーケンシャルにedgesを構築する" do
        jobnet1 = Tengine::Job::JobnetTemplate.new(:name => "jobnet1")
        jobnet1 .children << jobnet11 = Tengine::Job::JobnetTemplate.new(:name => "jobnet11")
        jobnet11.children << job111   = Tengine::Job::ScriptTemplate.new(:name => "job111", :script => "job111.sh")
        jobnet11.children << job112   = Tengine::Job::ScriptTemplate.new(:name => "job112", :script => "job112.sh")
        jobnet1 .children << finally = Tengine::Job::JobnetTemplate.new(:name => "finally", :jobnet_type_key => :finally)
        finally.children << job121   = Tengine::Job::ScriptTemplate.new(:name => "job121", :script => "job121.sh")
        finally.children << job122   = Tengine::Job::ScriptTemplate.new(:name => "job122", :script => "job122.sh")

        jobnet1.build_sequencial_edges
        jobnet1.save!

        jobnet1.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::JobnetTemplate,
          Tengine::Job::JobnetTemplate, # :finallyはEndの前にあります。
          Tengine::Job::End
        ]
        jobnet1.finally_jobnet.should == finally

        jobnet1.edges.map{|edge| [edge.origin_id, edge.destination_id]}.should == [
          [jobnet1.children.first.id, jobnet11.id],
          [jobnet11.id, jobnet1.children.last.id],
        ]
        jobnet11.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::End
        ]
        jobnet11.edges.map{|edge| [edge.origin_id, edge.destination_id]}.should == [
          [jobnet11.children.first.id, job111.id],
          [job111.id, job112.id],
          [job112.id, jobnet11.children.last.id],
        ]
        finally.children.map(&:class).should == [
          Tengine::Job::Start,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::ScriptTemplate,
          Tengine::Job::End
        ]
        finally.edges.map{|edge| [edge.origin_id, edge.destination_id]}.should == [
          [finally.children.first.id, job121.id],
          [job121.id, job122.id],
          [job122.id, finally.children.last.id],
        ]
      end
    end
  end

  context "並列処理" do

    describe :join do
      # job1 ---|
      #         |--- job4 ---|
      # job2 ---|            |
      #                      |--- job5
      # job3 ----------------|
      #
      # とMMでは書いていたものはこんな感じになります。
      #
      #          |--- job1 ---|
      #          |            J--- job4 ---|
      # start ---F--- job2 ---|            |
      #          |                         J--- job5 --- end
      #          |--- job3 ----------------|
      it do
        jobnet1 = Tengine::Job::JobnetTemplate.new(:name => "jobnet1")
        jobnet1.children << _start = Tengine::Job::Start.new
        jobnet1.children << fork1  = Tengine::Job::Fork.new
        jobnet1.children << job1   = Tengine::Job::ScriptTemplate.new(:name => "job1", :script => "job1.sh")
        jobnet1.children << job2   = Tengine::Job::ScriptTemplate.new(:name => "job2", :script => "job2.sh")
        jobnet1.children << join1  = Tengine::Job::Join.new
        jobnet1.children << job3   = Tengine::Job::ScriptTemplate.new(:name => "job3", :script => "job3.sh")
        jobnet1.children << job4   = Tengine::Job::ScriptTemplate.new(:name => "job4", :script => "job4.sh")
        jobnet1.children << join2  = Tengine::Job::Join.new
        jobnet1.children << job5   = Tengine::Job::ScriptTemplate.new(:name => "job5", :script => "job5.sh")
        jobnet1.children << _end   = Tengine::Job::End.new
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => _start.id, :destination_id => fork1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => fork1.id, :destination_id => job1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => fork1.id, :destination_id => job2.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => fork1.id, :destination_id => job3.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job1.id, :destination_id => join1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job2.id, :destination_id => join1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => join1.id, :destination_id => job4.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job3.id, :destination_id => join2.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job4.id, :destination_id => join2.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => join2.id, :destination_id => job5.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job5.id, :destination_id => _end.id)
        jobnet1.save!
      end
    end

    describe :fork do
      #         |--- job2
      # job1 ---|              |--- job4
      #         |--- job3 ---- |
      #                        |--- job5
      #
      # とMMでは書いていたものはこんな感じになります。
      #
      #                   |--- job2--------------------|
      #                   |                            |
      # start --- job1 ---F              |--- job4 --- J---end
      #                   |--- job3 ---- F             |
      #                                  |--- job5 ----|
      it do
        jobnet1 = Tengine::Job::JobnetTemplate.new(:name => "jobnet1")
        jobnet1.children << _start = Tengine::Job::Start.new
        jobnet1.children << job1   = Tengine::Job::ScriptTemplate.new(:name => "job1", :script => "job1.sh")
        jobnet1.children << fork1  = Tengine::Job::Fork.new
        jobnet1.children << job2   = Tengine::Job::ScriptTemplate.new(:name => "job2", :script => "job2.sh")
        jobnet1.children << job3   = Tengine::Job::ScriptTemplate.new(:name => "job3", :script => "job3.sh")
        jobnet1.children << fork2  = Tengine::Job::Fork.new
        jobnet1.children << job4   = Tengine::Job::ScriptTemplate.new(:name => "job4", :script => "job4.sh")
        jobnet1.children << job5   = Tengine::Job::ScriptTemplate.new(:name => "job5", :script => "job5.sh")
        jobnet1.children << join1  = Tengine::Job::Join.new
        jobnet1.children << _end   = Tengine::Job::End.new
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => _start.id, :destination_id => job1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job1.id, :destination_id => fork1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => fork1.id, :destination_id => job2.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => fork1.id, :destination_id => job3.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job3.id, :destination_id => fork2.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => fork2.id, :destination_id => job4.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => fork2.id, :destination_id => job5.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job2.id, :destination_id => join1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job4.id, :destination_id => join1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => job5.id, :destination_id => join1.id)
        jobnet1.edges << Tengine::Job::Edge.new(:origin_id => join1.id, :destination_id => _end.id)
        jobnet1.save!
      end
    end

  end

end
