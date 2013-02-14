# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Dsl::Loader do
  before(:all) do
    Tengine.plugins.add(Tengine::Job::Dsl::Loader)
  end

  def load_dsl(filename)
    config = {
      :action => "load",
      :tengined => { :load_path => File.expand_path("../../dsls/#{filename}", __FILE__) },
    }
    @version = File.read(File.expand_path("../../dsls/VERSION", __FILE__)).strip
    @bootstrap = Tengine::Core::Bootstrap.new(config)
    @bootstrap.boot
  end

  describe "基本的なジョブDSL" do
    context "0013_hadoop_job_run.rb" do
      before{
        Tengine::Job::Template::Jobnet.delete_all
        load_dsl("0013_hadoop_job_run.rb")
      }

      it do
        root_jobnet = Tengine::Job::Template::Jobnet.by_name("jobnet0013")
        root_jobnet.should be_a(Tengine::Job::Template::RootJobnet)
        root_jobnet.tap do |j|
          j.respond_to?(:version).should be_false
          j.dsl_version.should == @version
          j.dsl_filepath.should == "0013_hadoop_job_run.rb"
          j.dsl_lineno.should == 21
          j.name.should == "jobnet0013"
          j.description.should == "ジョブネット0013"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::End,
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
          Tengine::Job::Template::Start,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::End,
        ]
        hadoop_job_run.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [hadoop_job_run.children[0], hadoop_job_run.children[1]],
          [hadoop_job_run.children[1], hadoop_job_run.children[2]],
          [hadoop_job_run.children[2], hadoop_job_run.children[3]],
        ]
        hadoop_job1 = hadoop_job_run.children[1]
        hadoop_job1.tap{|j| j.name.should == "hadoop_job1"}
        hadoop_job1.children.map(&:class).should == [
          Tengine::Job::Template::Start,
          Tengine::Job::Template::Fork,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::Join,
          Tengine::Job::Template::End,
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
          [Tengine::Job::Template::Start         , Tengine::Job::Template::Fork          ],
          [Tengine::Job::Template::Fork          , Tengine::Job::Template::Jobnet],
          [Tengine::Job::Template::Fork          , Tengine::Job::Template::Jobnet],
          [Tengine::Job::Template::Jobnet, Tengine::Job::Template::Join          ],
          [Tengine::Job::Template::Jobnet, Tengine::Job::Template::Join          ],
          [Tengine::Job::Template::Join          , Tengine::Job::Template::End           ],
        ]
        hadoop_job2 = hadoop_job_run.children[2]
        hadoop_job2.tap{|j| j.name.should == "hadoop_job2"}
        hadoop_job2.children.map(&:class).should == [
          Tengine::Job::Template::Start,
          Tengine::Job::Template::Fork,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::Jobnet,
          Tengine::Job::Template::Join,
          Tengine::Job::Template::End,
        ]
      end
    end

    context "0014_join_and_join.rb" do
      before{
        Tengine::Job::Template::Jobnet.delete_all
        load_dsl("0014_join_and_join.rb")
      }

      it do
        root_jobnet = Tengine::Job::Template::Jobnet.by_name("jobnet0014")
        root_jobnet.should be_a(Tengine::Job::Template::RootJobnet)
        root_jobnet.tap do |j|
          j.respond_to?(:version).should be_false
          j.dsl_version.should == @version
          j.dsl_filepath.should == "0014_join_and_join.rb"
          j.dsl_lineno.should == 12
          j.name.should == "jobnet0014"
          j.description.should == "jobnet0014"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start         , # 0
          Tengine::Job::Template::Jobnet, # 1
          Tengine::Job::Template::Jobnet, # 2
          Tengine::Job::Template::Jobnet, # 3
          Tengine::Job::Template::Jobnet, # 4
          Tengine::Job::Template::Jobnet, # 5
          Tengine::Job::Template::Fork          , # 6
          Tengine::Job::Template::Join          , # 7
          Tengine::Job::Template::Join          , # 8
          Tengine::Job::Template::End           , # 9
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

    context "0015_fork_and_fork.rb" do
      before{
        Tengine::Job::Template::Jobnet.delete_all
        load_dsl("0015_fork_and_fork.rb")
      }

      it do
        root_jobnet = Tengine::Job::Template::Jobnet.by_name("jobnet0015")
        root_jobnet.should be_a(Tengine::Job::Template::RootJobnet)
        root_jobnet.tap do |j|
          j.respond_to?(:version).should be_false
          j.dsl_version.should == @version
          j.dsl_filepath.should == "0015_fork_and_fork.rb"
          j.dsl_lineno.should == 11
          j.name.should == "jobnet0015"
          j.description.should == "jobnet0015"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start         , # 0
          Tengine::Job::Template::Jobnet, # 1
          Tengine::Job::Template::Jobnet, # 2
          Tengine::Job::Template::Jobnet, # 3
          Tengine::Job::Template::Jobnet, # 4
          Tengine::Job::Template::Jobnet, # 5
          Tengine::Job::Template::Fork          , # 6
          Tengine::Job::Template::Fork          , # 7
          Tengine::Job::Template::Join          , # 8
          Tengine::Job::Template::End           , # 9
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

    context "0016_complex_fork_and_join.rb" do
      before{
        Tengine::Job::Template::Jobnet.delete_all
        load_dsl("0016_complex_fork_and_join.rb")
      }

      it do
        root_jobnet = Tengine::Job::Template::Jobnet.by_name("jobnet0016")
        root_jobnet.should be_a(Tengine::Job::Template::RootJobnet)
        root_jobnet.tap do |j|
          j.respond_to?(:version).should be_false
          j.dsl_version.should == @version
          j.dsl_filepath.should == "0016_complex_fork_and_join.rb"
          j.dsl_lineno.should == 11
          j.name.should == "jobnet0016"
          j.description.should == "jobnet0016"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start         , # 0
          Tengine::Job::Template::Jobnet, # 1
          Tengine::Job::Template::Jobnet, # 2
          Tengine::Job::Template::Jobnet, # 3
          Tengine::Job::Template::Jobnet, # 4
          Tengine::Job::Template::Jobnet, # 5
          Tengine::Job::Template::Jobnet, # 6
          Tengine::Job::Template::Jobnet, # 7
          Tengine::Job::Template::Fork          , # 8
          Tengine::Job::Template::Fork          , # 9
          Tengine::Job::Template::Fork          , # 10
          Tengine::Job::Template::Join          , # 11
          Tengine::Job::Template::Join          , # 12
          Tengine::Job::Template::End           , # 13
        ]
        (1..7).each do |idx|
          root_jobnet.children[idx].tap{|j|
            j.name.should == "job#{idx}"
            j.description.should == "job#{idx}"
            j.script.should == "echo 'job#{idx}'"
          }
        end

        root_jobnet.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [root_jobnet.children[ 0], root_jobnet.children[ 8]],
          [root_jobnet.children[ 8], root_jobnet.children[ 1]],
          [root_jobnet.children[ 8], root_jobnet.children[ 2]],

          [root_jobnet.children[ 2], root_jobnet.children[ 9]],
          [root_jobnet.children[ 9], root_jobnet.children[ 7]],


          [root_jobnet.children[ 3], root_jobnet.children[10]],
          [root_jobnet.children[10], root_jobnet.children[ 4]],
          [root_jobnet.children[11], root_jobnet.children[ 6]],
          [root_jobnet.children[ 9], root_jobnet.children[11]],
          [root_jobnet.children[10], root_jobnet.children[11]],
          [root_jobnet.children[ 1], root_jobnet.children[ 3]],
          [root_jobnet.children[ 4], root_jobnet.children[ 5]],
          [root_jobnet.children[ 6], root_jobnet.children[12]],
          [root_jobnet.children[ 7], root_jobnet.children[12]],
          [root_jobnet.children[ 5], root_jobnet.children[12]],
          [root_jobnet.children[12], root_jobnet.children[13]],
        ]
      end
    end

    context "0017_finally.rb" do
      before{
        Tengine::Job::Template::Jobnet.delete_all
        load_dsl("0017_finally.rb")
      }

      it do
        root_jobnet = Tengine::Job::Template::Jobnet.by_name("jobnet0017")
        root_jobnet.should be_a(Tengine::Job::Template::RootJobnet)
        root_jobnet.tap do |j|
          j.respond_to?(:version).should be_false
          j.dsl_version.should == @version
          j.dsl_filepath.should == "0017_finally.rb"
          j.dsl_lineno.should == 5
          j.name.should == "jobnet0017"
          j.description.should == "ジョブネット0017"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start         , # 0
          Tengine::Job::Template::Jobnet, # 1
          Tengine::Job::Template::Jobnet, # 2
          Tengine::Job::Template::Jobnet, # 3
          Tengine::Job::Template::Jobnet, # 4
          Tengine::Job::Template::End           , # 5
        ]
        root_jobnet.children[1].tap{|j| j.name.should == "job1"; j.description.should == "ジョブ1"; j.script.should == "job1.sh"}
        root_jobnet.children[2].tap{|j| j.name.should == "job2"; j.description.should == "ジョブ2"; j.script.should == "job2.sh"}
        root_jobnet.children[3].tap{|j| j.name.should == "job3"; j.description.should == "ジョブ3"; j.script.should == "job3.sh"}
        root_jobnet.children[4].tap{|j|
          j.name.should == "finally"
          j.description.should == "finally"
          j.jobnet_type_key.should == :finally
        }

        root_jobnet.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [root_jobnet.children[0], root_jobnet.children[1]],
          [root_jobnet.children[1], root_jobnet.children[2]],
          [root_jobnet.children[2], root_jobnet.children[3]],
          [root_jobnet.children[3], root_jobnet.children[5]],
        ]

        finally_jobnet = root_jobnet.children[4]
        finally_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start         , # 0
          Tengine::Job::Template::Jobnet, # 1
          Tengine::Job::Template::Jobnet, # 2
          Tengine::Job::Template::End           , # 3
        ]
        finally_jobnet.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [finally_jobnet.children[0], finally_jobnet.children[1]],
          [finally_jobnet.children[1], finally_jobnet.children[2]],
          [finally_jobnet.children[2], finally_jobnet.children[3]],
        ]
      end
    end

    context "0018_expansion.rb" do
      before{
        Tengine::Job::Template::Jobnet.delete_all
        load_dsl("0018_expansion.rb")
      }

      it do
        root_jobnet = Tengine::Job::Template::Jobnet.by_name("jobnet0018")
        root_jobnet.should be_a(Tengine::Job::Template::RootJobnet)
        root_jobnet.tap do |j|
          j.respond_to?(:version).should be_false
          j.dsl_version.should == @version
          j.dsl_filepath.should == "0018_expansion.rb"
          j.dsl_lineno.should == 19
          j.name.should == "jobnet0018"
          j.description.should == "jobnet0018"
          j.server_name.should == nil
          j.credential_name.should == nil
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start    , # 0
          Tengine::Job::Template::Expansion, # 1
          Tengine::Job::Template::Expansion, # 2
          Tengine::Job::Template::End      , # 3
        ]
        root_jobnet.children[1].tap{|j| j.name.should == "jobnet0018_01" }
        root_jobnet.children[2].tap{|j| j.name.should == "jobnet0018_02" }

        root_jobnet.edges.map{|edge| [edge.origin, edge.destination]}.should == [
          [root_jobnet.children[0], root_jobnet.children[1]],
          [root_jobnet.children[1], root_jobnet.children[2]],
          [root_jobnet.children[2], root_jobnet.children[3]],
        ]
        # expansion実行スケジュール登録時に参照するルートジョブネットをコピーするので
        # テンプレートでは子要素を持ちません。
        root_jobnet.children[1].children.should be_empty
        root_jobnet.children[2].children.should be_empty
      end
    end

    context "0021_caption.rb" do
      before{
        Tengine::Job::Template::Jobnet.delete_all
        load_dsl("0021_caption.rb")
      }

      it do
        root_jobnet = Tengine::Job::Template::Jobnet.by_name("jobnet0021")
        root_jobnet.should be_a(Tengine::Job::Template::RootJobnet)
        root_jobnet.tap do |j|
          j.respond_to?(:version).should be_false
          j.dsl_version.should == @version
          j.dsl_filepath.should == "0021_caption.rb"
          j.dsl_lineno.should == 5
          j.name.should == "jobnet0021"
          j.description.should == "ジョブネット0021"
          j.server_name.should == "i-11111111"
          j.credential_name.should == "goku-ssh-pk1"
        end
        root_jobnet.children.map(&:class).should == [
          Tengine::Job::Template::Start         , # 0
          Tengine::Job::Template::Jobnet, # 1
          Tengine::Job::Template::Jobnet, # 2
          Tengine::Job::Template::Jobnet, # 3
          Tengine::Job::Template::Jobnet, # 4
          Tengine::Job::Template::End           , # 5
        ]
        root_jobnet.children[1].tap{|j| j.name.should == "job1"; j.description.should == "ジョブ1"; j.script.should == "job1.sh"}
        root_jobnet.children[2].tap{|j| j.name.should == "job2"; j.description.should == "ジョブ2"; j.script.should == "job2.sh"}
        root_jobnet.children[3].tap{|j| j.name.should == "job3"; j.description.should == "ジョブ3"; j.script.should == "job3.sh"}
        root_jobnet.children[4].tap{|j| j.name.should == "hadoop_job_run4"; j.description.should == "Hadoopジョブ4"; j.script.should == "hadoop_job_run4.sh"}
      end
    end

  end

  context "<バグ>同じDSLバージョンで同一のルートジョブネット名が定義できてしまう" do
    it do
      Tengine::Job::Template::Jobnet.delete_all
      expect{
        load_dsl("0020_duplicated_jobnet_name.rb")
      }.to raise_error(Tengine::Job::Dsl::Error, "2 jobnet named \"jobnet0020\" found at 0020_duplicated_jobnet_name.rb:6 and 0020_duplicated_jobnet_name.rb:12")
    end
  end

  context "https://www.pivotaltracker.com/story/show/22350445" do
    context "2003_expansion" do
      before { Tengine::Job::Template::Jobnet.delete_all }

      context "expansion_5" do
        it do
          expect do
            load_dsl "2003_expansion/expansion_5.rb"
          end.should raise_error(Tengine::Job::Structure::Error)
        end
      end
    end
  end
end
