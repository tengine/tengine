# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'job_control_driver' do

  context "rjn0023" do
    shared_examples_for "conductorメソッド" do
      it "rjn0023のruby_job_conductor" do
        @root.ruby_job_conductor.should == Rjn0023CustomConductor::CONDUCTOR1
      end
      it "rjn0023のconductor" do
        expect{
          @root.conductor
        }.to raise_error("jobnet has no #conductor but #ruby_job_conductor and #ssh_conductor")
      end
      it "j1のconductorはrjn0023と同じ" do
        @root.element('j1').conductor.should == Rjn0023CustomConductor::CONDUCTOR1
      end
      it "j1のruby_job_conductorはrjn0023と同じ" do
        @root.element('j1').ruby_job_conductor.should == Rjn0023CustomConductor::CONDUCTOR1
      end
      it "j2のconductorはデフォルトと同じ" do
        @root.element('j2').conductor.should == Tengine::Job::RubyJob::DEFAULT_CONDUCTOR
      end
      it "j2のruby_job_conductorはデフォルトと同じ" do
        @root.element('j2').ruby_job_conductor.should == Tengine::Job::RubyJob::DEFAULT_CONDUCTOR
      end
    end

    context "actual" do
      before(:all) do
        Tengine::Job::Vertex.delete_all
        builder = Rjn0023CustomConductor.new
        @root = builder.create_actual
      end

      it_should_behave_like "conductorメソッド"
    end

    context "template" do
      before(:all) do
        Tengine::Job::Vertex.delete_all
        builder = Rjn0023CustomConductor.new
        @root = builder.create_template
      end

      it_should_behave_like "conductorメソッド"
    end
  end

end
