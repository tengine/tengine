# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

require 'active_support'
require "tengine/support/core_ext/hash/deep_dup"

describe "tengine/support/core_ext/hash/deep_dup" do

  original = {
    :a => {
      :b => {
        :c => :d
      }.freeze,
      :e => [
        :f,
        {:g => :h}.freeze,
        [:i, :j].freeze
      ].freeze
    }.freeze
  }.freeze

  context "Array#deep_dupがある場合" do
    before do
      load("tengine/support/core_ext/array/deep_dup.rb")
    end

    subject{ original.deep_dup }
    it { subject.should == original }
    it { subject.object_id.should_not == original.object_id }
    it { subject[:a].object_id.should_not == original[:a].object_id }
    it { subject[:a][:b].object_id.should_not == original[:a][:b].object_id }
    it { subject[:a][:e].object_id.should_not == original[:a][:e].object_id }
    it { subject[:a][:e][1].object_id.should_not == original[:a][:e][1].object_id }
    it { subject[:a][:e][2].object_id.should_not == original[:a][:e][2].object_id }
  end

  context "Array#deep_dupがない場合" do
    before do
      if Array.instance_methods.include?(:deep_dup)
        Array.class_eval do
          remove_method(:deep_dup)
        end
      end
    end
    after do
      load("tengine/support/core_ext/array/deep_dup.rb")
    end

    subject{ original.deep_dup }
    it { subject.should == original }
    it { subject.object_id.should_not == original.object_id }
    it { subject[:a].object_id.should_not == original[:a].object_id }
    it { subject[:a][:b].object_id.should_not == original[:a][:b].object_id }

    context "オブジェクトが変わらない" do
      before do
        pending "なぜかobject_idが変わってしまう。" if RUBY_VERSION == "1.8.7"
      end

      it { subject[:a][:e].object_id.should     == original[:a][:e].object_id }
      it { subject[:a][:e][1].object_id.should     == original[:a][:e][1].object_id }
      it { subject[:a][:e][2].object_id.should     == original[:a][:e][2].object_id }
    end
  end

end
