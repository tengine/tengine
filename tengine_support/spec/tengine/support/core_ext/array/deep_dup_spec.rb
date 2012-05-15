# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

require 'active_support'
require "tengine/support/core_ext/array/deep_dup"

describe "tengine/support/core_ext/array/deep_dup" do

  original = [
    :a,
    [
      :b,
      [:c, :d].freeze,
      {
        :e => {
          :f => [:g, :h].freeze,
          :i => {:j => :k}.freeze,
        }.freeze
      }.freeze
    ].freeze
  ].freeze

  context "Hash#deep_dupがある場合" do
    before do
      load("tengine/support/core_ext/hash/deep_dup.rb")
    end

    subject{ original.deep_dup }
    it { subject.should == original }
    it { subject.object_id.should_not == original.object_id }
    it { subject[1].object_id.should_not == original[1].object_id }
    it { subject[1][1].object_id.should_not == original[1][1].object_id }
    it { subject[1][2].object_id.should_not == original[1][2].object_id }
    it { subject[1][2][:e].object_id.should_not  == original[1][2][:e].object_id }
    it { subject[1][2][:e][:f].object_id.should_not == original[1][2][:e][:f].object_id }
    it { subject[1][2][:e][:i].object_id.should_not  == original[1][2][:e][:i].object_id }
  end

  context "Hash#deep_dupがない場合" do
    before do
      if Hash.instance_methods.include?(:deep_dup)
        Hash.class_eval do
          undef deep_dup
        end
      end
    end
    after do
      load("tengine/support/core_ext/hash/deep_dup.rb")
    end

    subject{ original.deep_dup }
    it { subject.should == original }
    it { subject.object_id.should_not == original.object_id }
    it { subject[1].object_id.should_not == original[1].object_id }
    it { subject[1][1].object_id.should_not == original[1][1].object_id }

    context "オブジェクトが変わらない" do
      before do
        pending "なぜかobject_idが変わってしまう。" if RUBY_VERSION == "1.8.7"
      end

      it { subject[1][2].object_id.should == original[1][2].object_id }
      it { subject[1][2][:e].object_id.should  == original[1][2][:e].object_id }
      it { subject[1][2][:e][:f].object_id.should == original[1][2][:e][:f].object_id }
      it { subject[1][2][:e][:i].object_id.should  == original[1][2][:e][:i].object_id }
    end
  end

end
