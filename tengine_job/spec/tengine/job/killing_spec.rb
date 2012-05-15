# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Job::Killing do

  context "強制停止の設定" do
    before do
      builder = Rjn0011NestedForkJobnetBuilder.new
      @ctx = builder.context
      @root = builder.create_template
    end

    [:root, :j1100, :j1200, :j1300, :j1110, :j1120, :j1130, :j1140, :j1121, :j1131, :j1310].each do |name|
      context "#{name}のデフォルト" do
        subject { @ctx[name] }
        its(:killing_signals){ should == nil}
        its(:killing_signal_interval){ should == nil}
        its(:actual_killing_signals){ should == ['KILL']}
        its(:actual_killing_signal_interval){ should == Tengine::Job::Killing::DEFAULT_KILLING_SIGNAL_INTERVAL}
      end
    end

    context "j1100に明示的に設定されている場合" do
      before do
        @ctx[:j1100].tap do |j|
          j.killing_signals = ["INT", "HUP", "QUIT", "KILL"]
          j.killing_signal_interval = 30
        end
        @ctx[:j1130].tap do |j|
          j.killing_signals = ["HUP", "QUIT", "KILL"]
          j.killing_signal_interval = 60
        end
      end

      [:root, :j1200, :j1300, :j1310].each do |name|
        context "#{name} デフォルトのまま" do
          subject { @ctx[name] }
          its(:killing_signals){ should == nil}
          its(:killing_signal_interval){ should == nil}
          its(:actual_killing_signals){ should == ['KILL']}
          its(:actual_killing_signal_interval){ should == Tengine::Job::Killing::DEFAULT_KILLING_SIGNAL_INTERVAL}
        end
      end

      [:j1100].each do |name|
        context "#{name} は自身の値も変更されている" do
          subject { @ctx[name] }
          its(:killing_signals){ should == ['INT', 'HUP', 'QUIT', 'KILL']}
          its(:killing_signal_interval){ should == 30}
          its(:actual_killing_signals){ should == ['INT', 'HUP', 'QUIT', 'KILL']}
          its(:actual_killing_signal_interval){ should == 30}
        end
      end

      [:j1120, :j1140, :j1121].each do |name|
        context "#{name} はj1100の設定が反映される" do
          subject { @ctx[name] }
          its(:killing_signals){ should == nil}
          its(:killing_signal_interval){ should == nil}
          its(:actual_killing_signals){ should == ['INT', 'HUP', 'QUIT', 'KILL']}
          its(:actual_killing_signal_interval){ should == 30}
        end
      end

      [:j1130].each do |name|
        context "#{name} は自身の値も変更されている" do
          subject { @ctx[name] }
          its(:killing_signals){ should == ['HUP', 'QUIT', 'KILL']}
          its(:killing_signal_interval){ should == 60}
          its(:actual_killing_signals){ should == ['HUP', 'QUIT', 'KILL']}
          its(:actual_killing_signal_interval){ should == 60}
        end
      end

      [:j1131].each do |name|
        context "#{name} はj1130の設定が反映される" do
          subject { @ctx[name] }
          its(:killing_signals){ should == nil}
          its(:killing_signal_interval){ should == nil}
          its(:actual_killing_signals){ should == ['HUP', 'QUIT', 'KILL']}
          its(:actual_killing_signal_interval){ should == 60}
        end
      end

    end

  end



end
