# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::Handler do
  context :process_event do
    before do
      @handler = Tengine::Core::Handler.new
    end

    it "should call block if match" do
      mock_event = mock(:event)
      mock_event.stub!(:key).and_return("uuid")
      @handler.stub!(:match?).with(mock_event).and_return(true)
      mock_block = lambda{}
      @handler.should_receive(:instance_eval).with(&mock_block)
      @handler.process_event(mock_event, [mock_block])
    end

    it "should not call block unless match" do
      mock_event = mock(:event)
      mock_event.stub!(:key).and_return("uuid")
      @handler.stub!(:match?).with(mock_event).and_return(false)
      mock_block = lambda{}
      @handler.should_not_receive(:instance_eval).with(&mock_block)
      @handler.process_event(mock_event, [mock_block])
    end
  end

  describe :filter do
    it "はネストしたフィルタの情報を保持できる" do
      expected_hash = {
          :method => :or,
          :children => [
            {
              :method => :and,
              :children => [
                { :pattern => 'foo', :method => :find_or_update_session_true },
                { :pattern => 'bar', :method => :find_or_update_session_true },
              ]
            },
            { :method => :equal, :pattern => "baz"}
          ]
        }
      Tengine::Core::Driver.delete_all
      driver1 = Tengine::Core::Driver.new(:name => "driver1", :version => "123")
      driver1.handlers.new(:event_type_names => [:foo, :bar], :filter => expected_hash)
      driver1.save!
      loaded = Tengine::Core::Driver.find(driver1.id)
      handler1 = loaded.handlers.first
      # mongoの制約でSymbolのキーは文字列に変換される。
      handler1.filter.should == {
          'method' => :or,
          'children' => [
            {
              'method' => :and,
              'children' => [
                { 'pattern' => 'foo', 'method' => :find_or_update_session_true },
                { 'pattern' => 'bar', 'method' => :find_or_update_session_true },
              ]
            },
            { 'method' => :equal, 'pattern' => "baz"}
          ]
        }
    end


  end

end
