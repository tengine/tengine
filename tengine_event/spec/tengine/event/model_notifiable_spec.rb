# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Tengine::Event::ModelNotifiable" do

  module TengineTest
    class MockModel
      attr_accessor :attributes, :changes
      def initialize(attributes)
        @attributes = attributes
      end
    end
  end

  class TestModelNotifier
    include Tengine::Event::ModelNotifiable

    def initialize(sender)
      @sender= sender
    end

    def event_sender
      @sender
    end
  end

  context "ActiveModelなどのObserverでそれぞれメソッドが呼び出されます" do
    before do
      @mock_sender = mock(:sender)
      @notifier = TestModelNotifier.new(@mock_sender)
    end

    it "after_create" do
      @mock_sender.should_receive(:fire).with("TengineTest::MockModel.created.TestModelNotifier", {
          :level_key => :info,
          :properties => {
            :class_name => "TengineTest::MockModel",
            :attributes => {
              :name => "GariGariKun",
              :price => 50
           }
          }
        })
      @notifier.after_create(TengineTest::MockModel.new(:name => "GariGariKun", :price => 50))
    end

    it "after_update" do
      @mock_sender.should_receive(:fire).with("TengineTest::MockModel.updated.TestModelNotifier", {
          :level_key => :info,
          :properties => {
            :class_name => "TengineTest::MockModel",
            :attributes => {
              :name => "GariGariKun",
              :price => 60
            },
            :changes => {"price" => [50, 60]},
           }
        })
      model = TengineTest::MockModel.new(:name => "GariGariKun", :price => 60)
      model.changes = {"price" => [50, 60]}
      @notifier.after_update(model)
    end

    it "after_destroy" do
      @mock_sender.should_receive(:fire).with("TengineTest::MockModel.destroyed.TestModelNotifier", {
          :level_key => :info,
          :properties => {
            :class_name => "TengineTest::MockModel",
            :attributes => {
              :name => "GariGariKun",
              :price => 60
            }
          }
        })
      @notifier.after_destroy(TengineTest::MockModel.new(:name => "GariGariKun", :price => 60))
    end

  end

end
