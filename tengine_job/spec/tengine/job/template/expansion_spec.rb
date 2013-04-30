# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Template::Expansion do

  context "rjn0008" do
    before do
      Tengine::Job::Template::Vertex.delete_all
      Rjn0001SimpleJobnetBuilder.new.create_template
      Rjn0002SimpleParallelJobnetBuilder.new.create_template
      builder = Rjn0008ExpansionFixture.new
      @template = builder.create_template
      @ctx = builder.context
    end

    it "生成されたActualはrjn0001とrjn0002を含む" do
      actual = @template.generate
      actual.should be_a(Tengine::Job::Runtime::RootJobnet)
      actual.name_path.should == "/rjn0008"
      actual.name_path_until_expansion.should == "/rjn0008"
      actual.respond_to?(:actual_server_name).should be_false
      actual.respond_to?(:actual_server).should be_false
      actual.children.length.should == 4
      actual.children[0].tap{|j| j.should be_a(Tengine::Job::Runtime::Start)}
      actual.children[1].tap do |rjn0001|
        rjn0001.should be_a(Tengine::Job::Runtime::Jobnet)
        rjn0001.name.should == "rjn0001"
        rjn0001.name_path.should == "/rjn0008/rjn0001"
        rjn0001.name_path_until_expansion.should == "/rjn0001"
        rjn0001.respond_to?(:actual_server_name).should be_false
        rjn0001.respond_to?(:actual_server).should be_false
        rjn0001.respond_to?(:actual_credential_name).should be_false
        rjn0001.respond_to?(:actual_credential).should be_false
        rjn0001.was_expansion.should == true
        rjn0001.ancestors.should == [actual]
        rjn0001.ancestors_until_expansion.should == []
        rjn0001.children.length.should == 4
        rjn0001.children[0].tap{|j| j.should be_a(Tengine::Job::Runtime::Start)}
        rjn0001.children[1].tap do |j11|
          j11.name.should == "j11"
          j11.name_path.should == "/rjn0008/rjn0001/j11"
          j11.name_path_until_expansion.should == "/rjn0001/j11"
          j11.should be_a(Tengine::Job::Runtime::SshJob)
          j11.ancestors.should == [actual, rjn0001]
          j11.ancestors_until_expansion.should == [rjn0001]
          j11.actual_server_name.should == "test_server1"
          j11.actual_server.should_not == nil
          j11.actual_credential_name.should == "test_credential1"
          j11.actual_credential.should_not == nil
        end
        rjn0001.children[2].tap do |j12|
          j12.name.should == "j12"
          j12.name_path.should == "/rjn0008/rjn0001/j12"
          j12.name_path_until_expansion.should == "/rjn0001/j12"
          j12.should be_a(Tengine::Job::Runtime::SshJob)
          j12.ancestors.should == [actual, rjn0001]
          j12.ancestors_until_expansion.should == [rjn0001]
        end
        rjn0001.children[3].tap{|j| j.should be_a(Tengine::Job::Runtime::End)}
        rjn0001.edges.length.should == 3
      end
      actual.children[2].tap do |rjn0002|
        rjn0002.should be_a(Tengine::Job::Runtime::Jobnet)
        rjn0002.name.should == "rjn0002"
        rjn0002.name_path.should == "/rjn0008/rjn0002"
        rjn0002.name_path_until_expansion.should == "/rjn0002"
        rjn0002.was_expansion.should == true
        rjn0002.ancestors.should == [actual]
        rjn0002.ancestors_until_expansion.should == []
        rjn0002.children.length.should == 6
        rjn0002.children[0].tap{|j| j.should be_a(Tengine::Job::Runtime::Start)}
        rjn0002.children[1].tap{|j| j.should be_a(Tengine::Job::Runtime::Fork)}
        rjn0002.children[2].tap do |j11|
          j11.name.should == "j11"
          j11.name_path.should == "/rjn0008/rjn0002/j11"
          j11.name_path_until_expansion.should == "/rjn0002/j11"
          j11.should be_a(Tengine::Job::Runtime::SshJob)
          j11.ancestors.should == [actual, rjn0002]
          j11.ancestors_until_expansion.should == [rjn0002]
        end
        rjn0002.children[3].tap do |j12|
          j12.name.should == "j12"
          j12.name_path.should == "/rjn0008/rjn0002/j12"
          j12.name_path_until_expansion.should == "/rjn0002/j12"
          j12.should be_a(Tengine::Job::Runtime::SshJob)
          j12.ancestors.should == [actual, rjn0002]
          j12.ancestors_until_expansion.should == [rjn0002]
        end
        rjn0002.children[4].tap{|j| j.should be_a(Tengine::Job::Runtime::Join)}
        rjn0002.children[5].tap{|j| j.should be_a(Tengine::Job::Runtime::End)}
        rjn0002.edges.length.should == 6
      end
      actual.children[3].tap{|j| j.should be_a(Tengine::Job::Runtime::End)}
    end

  end

  context "複数のバージョンが混在する場合" do
    before do
      Tengine::Job::Template::Vertex.delete_all
      @jobnet1_ver1 = Rjn0001SimpleJobnetBuilder.new.create_template(:dsl_version => 1)
      @jobnet2_ver1 = Rjn0002SimpleParallelJobnetBuilder.new.create_template(:dsl_version => 1)
      @jobnet1_ver2 = Rjn0001SimpleJobnetBuilder.new.create_template(:dsl_version => 2)
      @jobnet2_ver2 = Rjn0002SimpleParallelJobnetBuilder.new.create_template(:dsl_version => 2)
      @jobnet1_ver3 = Rjn0001SimpleJobnetBuilder.new.create_template(:dsl_version => 3)
      @jobnet2_ver3 = Rjn0002SimpleParallelJobnetBuilder.new.create_template(:dsl_version => 3)
      builder = Rjn0008ExpansionFixture.new
      @template = builder.create_template(:dsl_version => 2)
      @ctx = builder.context
    end

    it { @template.child_by_name("rjn0001").root_jobnet_template.id.should == @jobnet1_ver2.id }
    it { @template.child_by_name("rjn0002").root_jobnet_template.id.should == @jobnet2_ver2.id }
  end

end
