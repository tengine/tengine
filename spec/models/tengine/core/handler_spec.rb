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

  describe :match? do
    context "without session" do
      # it "by source_name"
      # it "by sender_name"
      # it "by occurred_at"
    end

    context "with session" do
      context "foo & bar" do
        before do
          Tengine::Core::Driver.delete_all
          Tengine::Core::Session.delete_all
          @driver1 = Tengine::Core::Driver.new(:name => "driver1", :version => "123")
          @handler = @driver1.handlers.new(:event_type_names => [:foo, :bar], :filter => {
              'method' => :and,
              'children' => [
                { 'pattern' => 'foo', 'method' => :find_or_mark_in_session },
                { 'pattern' => 'bar', 'method' => :find_or_mark_in_session },
              ]
            })
          @driver1.save!
          @handler
        end
        subject{ @handler }

        it "最初にfooが来たらセッションに記録してfalse" do
          event_foo = FactoryGirl.create(:"tengine/core/event", :event_type_name => "foo")
          subject.match?(event_foo).should == false
          @driver1.session.system_properties.should == {'mark_foo' => true}
        end

        context "一度fooが来た場合" do
          before do
            session = @driver1.session
            session.system_properties = {'mark_foo' => true}
            session.save!
          end

          it "再度fooが来るとセッションは変更なくfalse" do
            event_foo = FactoryGirl.create(:"tengine/core/event", :event_type_name => "foo")
            subject.match?(event_foo).should == false
            @driver1.reload
            @driver1.session.system_properties.should == {'mark_foo' => true}
          end

          it "barが来るとセッションを変更してtrue" do
            event_bar = FactoryGirl.create(:"tengine/core/event", :event_type_name => "bar")
            subject.match?(event_bar).should == true
            @driver1.reload
            @driver1.session.system_properties.should == {'mark_foo' => true, 'mark_bar' => true}
          end

        end
      end

    end

  end


  describe 'filter persistence' do
    before do
      Tengine::Core::Driver.delete_all
      @driver1 = Tengine::Core::Driver.new(:name => "driver1", :version => "123")
    end

    it "デフォルトでは空のHash" do
      @driver1.handlers.new(:event_type_names => [:foo, :bar])
      @driver1.save!
      loaded = Tengine::Core::Driver.find(@driver1.id)
      handler1 = loaded.handlers.first
      handler1.filter.should == {}
    end

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
      @driver1.handlers.new(:event_type_names => [:foo, :bar], :filter => expected_hash)
      @driver1.save!
      loaded = Tengine::Core::Driver.find(@driver1.id)
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
