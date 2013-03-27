# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'amqp'
require 'time'

describe "Tengine::Event" do
  expected_source_name = "this_server1/12345"

  before do
    Tengine::Event.stub!(:host_name).and_return("this_server1")
    Process.stub!(:pid).and_return(12345)
  end

  # hack!
  after :each do
    EM.instance_eval do
      @next_tick_mutex.synchronize do
        @next_tick_queue = nil
      end
    end
  end

  describe :new_object do
    context "without config" do
      before do
        Tengine::Event.config = {}
        @now = Time.now
        Time.stub!(:now).and_return(@now)
      end

      it{ Tengine::Event.default_source_name.should == expected_source_name }
      it{ Tengine::Event.default_sender_name.should == expected_source_name }
      it{ Tengine::Event.default_level.should == 2 }

      subject{ Tengine::Event.new }
      it{ subject.should be_a(Tengine::Event) }
      its(:key){ should =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }
      its(:event_type_name){ should be_nil }
      its(:source_name){ should == expected_source_name}
      its(:occurred_at){ should == @now.utc }
      its(:level){ should == 2}
      its(:level_key){ should == :info}
      its(:sender_name){ should == expected_source_name }
      its(:properties){ should be_a(Hash) }
      its(:properties){ should be_empty }
      it {
        attrs = subject.attributes
        attrs.should be_a(Hash)
        attrs.delete(:key).should_not be_nil
        attrs.should == {
          :occurred_at => @now.utc,
          :level=>2,
          :source_name => expected_source_name,
          :sender_name => expected_source_name,
        }
      }
      it {
        hash = JSON.parse(subject.to_json)
        hash.should be_a(Hash)
        hash.delete('key').should =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
        hash.should == {
          'occurred_at' => @now.utc.iso8601,
          "level" => 2,
          'source_name' => expected_source_name,
          'sender_name' => expected_source_name,
        }
      }
    end

    context "with config" do
      before do
        Tengine::Event.config = {
          :default_source_name => "event_source1",
          :default_sender_name => "sender1",
          :default_level_key => :warn
        }
        @now = Time.now
        Time.stub!(:now).and_return(@now)
      end
      after do
        Tengine::Event.config = {}
      end

      it{ Tengine::Event.default_source_name.should == "event_source1" }
      it{ Tengine::Event.default_sender_name.should == "sender1" }
      it{ Tengine::Event.default_level.should == 3 }

      subject{ Tengine::Event.new }
      it{ subject.should be_a(Tengine::Event) }
      its(:key){ should =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }
      its(:event_type_name){ should be_nil }
      its(:source_name){ should == "event_source1"}
      its(:occurred_at){ should == @now.utc }
      its(:level){ should == 3}
      its(:level_key){ should == :warn}
      its(:sender_name){ should == "sender1" }
      its(:properties){ should be_a(Hash) }
      its(:properties){ should be_empty }
      it {
        attrs = subject.attributes
        attrs.should be_a(Hash)
        attrs.delete(:key).should_not be_nil
        attrs.should == {
          :occurred_at => @now.utc,
          :level=>3,
          :source_name => "event_source1",
          :sender_name => "sender1",
        }
      }
      it {
        hash = JSON.parse(subject.to_json)
        hash.should be_a(Hash)
        hash.delete('key').should =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
        hash.should == {
          'occurred_at' => @now.utc.iso8601,
          'level'=>3,
          'source_name' => "event_source1",
          'sender_name' => "sender1",
        }
      }
    end

  end

  describe :new_object_with_attrs do
    subject{ Tengine::Event.new(
        :event_type_name => :foo,
        :key => "hoge",
        'source_name' => "server1",
        :occurred_at => Time.utc(2011,8,11,12,0),
        :level_key => 'error',
        'sender_name' => "server2",
        :properties => {:bar => "ABC", :baz => 999}
        )}
    it{ subject.should be_a(Tengine::Event) }
    its(:key){ should == "hoge" }
    its(:event_type_name){ should == "foo" }
    its(:source_name){ should == "server1" }
    its(:occurred_at){ should == Time.utc(2011,8,11,12,0) }
    its(:level){ should == 4}
    its(:level_key){ should == :error}
    its(:sender_name){ should == "server2" }
    its(:properties){ should == {'bar' => "ABC", 'baz' => 999}}
    it {
      attrs = subject.attributes
      attrs.should == {
        :event_type_name => 'foo',
        :key => "hoge",
        :source_name => "server1",
        :occurred_at => Time.utc(2011,8,11,12,0),
        :level => 4,
        :sender_name => "server2",
        :properties => {'bar' => "ABC", 'baz' => 999}
      }
    }
    it {
      hash = JSON.parse(subject.to_json)
      hash.should be_a(Hash)
      hash.should == {
        "level"=>4,
        'event_type_name' => 'foo',
        'key' => "hoge",
        'source_name' => "server1",
        'occurred_at' => "2011-08-11T12:00:00Z", # Timeオブジェクトは文字列に変換されます
        'sender_name' => "server2",
        'properties' => {'bar' => "ABC", 'baz' => 999}
      }
    }
  end

  describe 'occurred_at with local_time should convert to UTC' do
    subject{ Tengine::Event.new(
        :occurred_at => Time.parse("2011-08-31 12:00:00 +0900"),
        :key => 'hoge'
        )}
    it{ subject.should be_a(Tengine::Event) }
    its(:occurred_at){ should == Time.utc(2011,8,31,3,0) }
    its(:occurred_at){ should be_utc }
    it {
      hash = JSON.parse(subject.to_json)
      hash.should be_a(Hash)
      hash.should == {
        "level"=>2,
        'key' => "hoge",
        'occurred_at' => "2011-08-31T03:00:00Z", # Timeオブジェクトは文字列に変換されます
        'source_name' => "this_server1/12345",
        'sender_name' => "this_server1/12345",
      }
    }
  end

  it 'attrs_for_new must be Hash' do
    expect{
      Tengine::Event.new("{foo: 1, bar: 2}")
    }.to raise_error(ArgumentError, /attrs must be a Hash but was/)
  end


  describe :occurred_at do
    context "valid nil" do
      subject{ Tengine::Event.new(:occurred_at => nil) }
      it do
        subject.occurred_at = nil
        subject.occurred_at.should == nil
      end
    end
    context "valid String" do
      subject{ Tengine::Event.new(:occurred_at => "2011-08-31 12:00:00 +0900") }
      its(:occurred_at){ should be_a(Time); should == Time.utc(2011, 8, 31, 3)}
    end
    it "invalid Class: Range" do
      expect{
        Tengine::Event.new(:occurred_at => (1..3))
      }.to raise_error(ArgumentError)
    end
  end
  it 'occurred_at must be Time' do
    expect{
      Tengine::Event.new(:occurred_at => "invalid time string")
    }.to raise_error(ArgumentError, /no time information/)
  end

  describe :level do
    context :valid_levels do
      {
        0 => :gr_heartbeat,
        1 => :debug,
        2 => :info,
        3 => :warn,
        4 => :error,
        5 => :fatal,
      }.each do |level, level_key|
        context "set by level" do
          subject{ Tengine::Event.new(:level => level) }
          its(:level_key){ should == level_key}
        end
        context "set Symbol by level_key" do
          subject{ Tengine::Event.new(:level_key => level_key.to_sym) }
          its(:level){ should == level}
          its(:level_key){ should == level_key.to_sym}
        end
        context "set String by level_key" do
          subject{ Tengine::Event.new(:level_key => level_key.to_s) }
          its(:level){ should == level}
          its(:level_key){ should == level_key.to_sym}
        end
      end
    end

    context 'invalid_level values' do
      [-100, 10, -5 -1, 6, 10, 100].each do |value|
        it value do
          expect{
            Tengine::Event.new(:level => value)
          }.to raise_error(ArgumentError)
        end
      end
    end

    context 'invalid_level keys' do
      [:unknown , :zero , :INFO].each do |key|
        it key.inspect do
          expect{
            Tengine::Event.new(:level_key => key)
          }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe :properties do
    subject{ Tengine::Event.new }
    it "valid usage" do
      subject.properties.should == {}
      subject.properties = {:foo => 123}
      subject.properties.should == {'foo' => 123}
      subject.properties = {:bar => 456}
      subject.properties.should == {'bar' => 456}
    end
    it "assign nil" do
      subject.properties = nil
      subject.properties.should == {}
    end
  end


  describe :fire do
    before do
      Tengine::Event.config = {
        :connection => {"foo" => "aaa"},
        :exchange => {'name' => "exchange1", 'type' => 'direct', 'durable' => true, 'publish' => {'persistent' => true}},
        :queue => {'name' => "queue1", 'durable' => true},
      }
      @mock_connection = mock(:connection)
      @mock_channel = mock(:channel)
      @mock_exchange = mock(:exchange)
      AMQP.should_receive(:connect).with(an_instance_of(Hash)).and_yield(@mock_connection).and_return(@mock_connection)
      @mock_connection.stub(:connected?).and_return(true)
      @mock_connection.stub(:disconnect).and_yield
      @mock_connection.stub(:server_capabilities).and_return(nil)
      AMQP::Channel.should_receive(:new).with(@mock_connection, an_instance_of(Fixnum), an_instance_of(Hash)).and_yield(@mock_channel).and_return(@mock_channel)
      @mock_channel.stub(:publisher_index).and_return(nil)
      AMQP::Exchange.should_receive(:new).with(@mock_channel, :direct, "exchange1",
        :passive=>false, :durable=>true, :auto_delete=>false, :internal=>false, :nowait=>false).and_yield(@mock_exchange).and_return(@mock_exchange)
      @mock_channel.stub(:close)
    end

    it "JSON形式にserializeしてexchangeにpublishする" do
      expected_event = Tengine::Event.new(:event_type_name => :foo, :key => "uniq_key")
      @mock_exchange.should_receive(:publish).with(expected_event.to_json, :persistent => true, :content_type => "application/json")
      EM.run_test do
        Tengine::Event.fire(:foo, :key => "uniq_key")
        EM.add_timer(0.1) do
          EM.next_tick do
            EM.stop
          end
        end
      end
    end
  end


  describe :parse do
    context "can parse valid json object" do
      subject do
        source = Tengine::Event.new(
          :event_type_name => :foo,
          :key => "hoge",
          'source_name' => "server1",
          :occurred_at => Time.utc(2011,8,11,12,0),
          :level_key => 'error',
          'sender_name' => "server2",
          :properties => {:bar => "ABC", :baz => 999}
          )
        Tengine::Event.parse(source.to_json)
      end
      its(:key){ should == "hoge" }
      its(:event_type_name){ should == "foo" }
      its(:source_name){ should == "server1" }
      its(:occurred_at){ should == Time.utc(2011,8,11,12,0) }
      its(:level){ should == 4}
      its(:level_key){ should == :error}
      its(:sender_name){ should == "server2" }
      its(:properties){ should == {'bar' => "ABC", 'baz' => 999}}
    end

    context "can parse valid json array" do
      before do
        source1 = Tengine::Event.new(
          :event_type_name => :foo,
          :key => "hoge1",
          'source_name' => "server1",
          :occurred_at => Time.utc(2011,8,11,12,0),
          :level_key => 'error',
          'sender_name' => "server2",
          :properties => {:bar => "ABC", :baz => 999}
          )
        source2 = Tengine::Event.new(
          :event_type_name => :bar,
          :key => "hoge2",
          'source_name' => "server3",
          :occurred_at => Time.utc(2011,9,24,15,50),
          :level_key => 'warn',
          'sender_name' => "server4",
          :properties => {:bar => "DEF", :baz => 777}
          )
        @parsed = Tengine::Event.parse([source1, source2].to_json)
      end

      context "first" do
        subject{ @parsed.first }
        its(:key){ should == "hoge1" }
        its(:event_type_name){ should == "foo" }
        its(:source_name){ should == "server1" }
        its(:occurred_at){ should == Time.utc(2011,8,11,12,0) }
        its(:level){ should == 4}
        its(:level_key){ should == :error}
        its(:sender_name){ should == "server2" }
        its(:properties){ should == {'bar' => "ABC", 'baz' => 999}}
      end

      context "last" do
        subject{ @parsed.last }
        its(:key){ should == "hoge2" }
        its(:event_type_name){ should == "bar" }
        its(:source_name){ should == "server3" }
        its(:occurred_at){ should == Time.utc(2011,9,24,15,50) }
        its(:level){ should == 3}
        its(:level_key){ should == :warn}
        its(:sender_name){ should == "server4" }
        its(:properties){ should == {'bar' => "DEF", 'baz' => 777}}
      end
    end

    it "raise ArgumentError for invalid attribute name" do
      expect{
        Tengine::Event.parse({'name' => :foo}.to_json)
      }.to raise_error(NoMethodError)
    end

  end

  describe "#transmitted?" do

    subject { Tengine::Event.new }

    it "returns false while not transmitted" do
      Tengine::Mq::Suite.stub(:pending?).with(subject).and_return(true)
      subject.transmitted?.should be_false
    end

    it "returns true once transmitted" do
      Tengine::Mq::Suite.stub(:pending?).with(subject).and_return(false)
      subject.transmitted?.should be_true
    end
  end

end
