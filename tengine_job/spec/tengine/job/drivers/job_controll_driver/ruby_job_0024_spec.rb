# -*- coding: utf-8 -*-
require 'spec_helper'
require 'tengine/rspec'

describe 'job_control_driver' do
  include Tengine::RSpec::Extension

  target_dsl File.expand_path("../../../../../lib/tengine/job/drivers/job_control_driver.rb", File.dirname(__FILE__))
  driver :job_control_driver

  context "rjn0024" do
    before do
      Tengine::Job::Vertex.delete_all
      builder = Rjn0024ExplicitSucceedAndFailFixture.new
      @root = builder.create_actual
      @ctx = builder.context
      @execution = Tengine::Job::Execution.create!({
          :root_jobnet_id => @root.id,
        })
      @root.phase_key = :starting
      @ctx.vertex('jn01').phase_key = :starting
      @ctx.vertex('jn02').phase_key = :starting
      job_names =
        (1..6).map{|idx| "j0#{idx}@/rjn0024/jn01"} +
        (7..9).map{|idx| "j0#{idx}@/rjn0024/jn02"} +
        (10..12).map{|idx| "j#{idx}@/rjn0024"}
      job_names.each do |job_name|
        @root.element(job_name).tap do |j|
          j.phase_key = :ready
          j.prev_edges.first.phase_key = :transmitted
        end
      end
      @root.save!
      @root.reload
    end

    def assert_success(job_name)
      @__kernel__.should_receive(:fire).with(:"success.job.job.tengine", an_instance_of(Hash)) do |_, hash|
        hash[:source_name].should == @ctx.vertex(job_name).name_as_resource
        props = hash[:properties]
        @base_props.each do |key, value|
          props[key].should == value
        end
        props[:target_job_id].should == @ctx.vertex(job_name).id.to_s
        props[:target_job_name_path].should == @ctx.vertex(job_name).name_path
        yield(hash) if block_given?
      end
      tengine.receive("start.job.job.tengine", :properties => {
          :target_job_id => @ctx.vertex(job_name).id.to_s,
          :target_job_name_path => @ctx.vertex(job_name).name_path,
        }.update(@base_props))
      @root.reload
      @ctx.vertex(job_name).prev_edges.first.phase_key.should == :transmitted
      @ctx.vertex(job_name).phase_key.should == :success
    end

    def assert_error(job_name)
      @__kernel__.should_receive(:fire).with(:"error.job.job.tengine", an_instance_of(Hash)) do |_, hash|
        hash[:source_name].should == @ctx.vertex(job_name).name_as_resource
        props = hash[:properties]
        @base_props.each do |key, value|
          props[key].should == value
        end
        props[:target_job_id].should == @ctx.vertex(job_name).id.to_s
        props[:target_job_name_path].should == @ctx.vertex(job_name).name_path
        yield(hash) if block_given?
      end
      tengine.receive("start.job.job.tengine", :properties => {
          :target_job_id => @ctx.vertex(job_name).id.to_s,
          :target_job_name_path => @ctx.vertex(job_name).name_path,
        }.update(@base_props))
      @root.reload
      @ctx.vertex(job_name).prev_edges.first.phase_key.should == :transmitted
      @ctx.vertex(job_name).phase_key.should == :error
    end

    context "jn01" do
      before do
        @base_props = {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path,
          :target_jobnet_id => @ctx.vertex(:jn01).id.to_s,
          :target_jobnet_name_path => @ctx.vertex(:jn01).name_path,
        }
      end

      it "j01" do
        STDOUT.should_receive(:puts).with("j01 end")
        assert_success(:j01)
      end

      it "j02" do
        STDOUT.should_receive(:puts).with("j02 end")
        assert_success(:j02) do |hash|
          hash[:properties][:message].should == "j02 success"
        end
      end

      it "j03" do
        STDOUT.should_receive(:puts).with("j03 end")
        assert_error(:j03) do |hash|
          hash[:properties][:message].should =~ /^\[RuntimeError\]/
        end
      end

      it "j04" do
        STDOUT.should_receive(:puts).with("j04 end")
        assert_error(:j04) do |hash|
          hash[:properties][:message].should == "j04 failed"
        end
      end

      it "j05" do
        STDOUT.should_receive(:puts).with("j05 end")
        assert_error(:j05)
      end

      it "j06" do
        STDOUT.should_receive(:puts).with("j06 end")
        assert_success(:j06)
      end
    end

    context "jn02" do
      before do
        @base_props = {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path,
          :target_jobnet_id => @ctx.vertex(:jn02).id.to_s,
          :target_jobnet_name_path => @ctx.vertex(:jn02).name_path,
        }
      end


      it "j07" do
        STDOUT.should_receive(:puts).with("j07 end")
        assert_success(:j07)
      end

      it "j08" do
        assert_success(:j08) do |hash|
          hash[:properties][:message].should == "j08 success"
        end
      end

      it "j09" do
        assert_error(:j09) do |hash|
          hash[:properties][:message].should == "j09 failed"
        end
      end
    end

    context "others" do
      before do
        @base_props = {
          :execution_id => @execution.id.to_s,
          :root_jobnet_id => @root.id.to_s,
          :root_jobnet_name_path => @root.name_path,
          :target_jobnet_id => @root.id.to_s,
          :target_jobnet_name_path => @root.name_path,
        }
      end

      it "j10" do
        STDOUT.should_receive(:puts).with("j10 end")
        assert_success(:j10)
      end

      it "j11" do
        STDOUT.should_receive(:puts).with("j11 end")
        assert_success(:j11)
      end

      it "j12" do
        STDOUT.should_receive(:puts).with("j12 end")
        assert_error(:j12)
      end
    end

  end

end
