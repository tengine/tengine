# -*- coding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)

# fire の機能面(何を送信するか等)に関してはmq/suiteに記載済み
describe "Tengine::Event::Sender" do
  describe "#initialize" do
    context "no args" do
      subject{ Tengine::Event::Sender.new.mq_suite }
      it { should_not be_nil }
      it { should be_kind_of Tengine::Mq::Suite }
    end

    context "with options" do
      subject{ Tengine::Event::Sender.new(:exchange => {:name => "another_exhange"}).mq_suite.config[:exchange][:name] }
      it { should == "another_exhange" }
    end

    context "with mq_suite" do
      before{ @mq_suite = Tengine::Mq::Suite.new }
      subject{ Tengine::Event::Sender.new(@mq_suite).mq_suite }
      it { should == @mq_suite }
    end

    context "with mq_suite and options" do
      before do
        @mq_suite = Tengine::Mq::Suite.new
        @logger = mock(:logger)
      end
      subject { Tengine::Event::Sender.new(@mq_suite, :logger => @logger) }
      its (:mq_suite) { should == @mq_suite }
      its (:logger) { should == @logger }
    end
  end

  describe "#stop" do
    before { @mq_suite = Tengine::Mq::Suite.new }
    subject { Tengine::Event::Sender.new(@mq_suite) }

    it "stops suite" do
      @mq_suite.should_receive :stop
      subject.stop
    end

    it "calls the given block (if any) afterwards" do
      @mq_suite.should_receive(:stop).and_yield
      block_called = false
      subject.stop { block_called = true }
      block_called.should == true
    end
  end

  describe "#pending_events" do
    before do
      @mq_suite = Tengine::Mq::Suite.new
      @event = Tengine::Event.new
      @mq_suite.stub(:pending_events_for).with(an_instance_of(Tengine::Event::Sender)).and_return([@event])
    end
    subject { Tengine::Event::Sender.new(@mq_suite).pending_events }

    it { should be_kind_of Array }
    it { should have(1).events }
    it { should include(@event) }
  end

  describe "#wait_for_connection" do
    it "does nothing" do
      expect {
        Tengine::Event::Sender.new.wait_for_connection {  }
      }.to_not raise_error
    end
  end

  describe "#fire" do
    before do
      @event = Tengine::Event.new
      @mq_suite = Tengine::Mq::Suite.new
      @mq_suite.stub(:fire).
        with(an_instance_of(Tengine::Event::Sender),
             an_instance_of(Tengine::Event),
             an_instance_of(Hash),
             an_instance_of(Proc)) {
        |q, w, e, r|
        r.yield
      }
      @mq_suite.stub(:fire).
        with(an_instance_of(Tengine::Event::Sender),
             an_instance_of(Tengine::Event),
             an_instance_of(Hash),
             an_instance_of(NilClass))
    end

    context "mandatory one arg" do
      it { expect { Tengine::Event::Sender.new(@mq_suite).fire }.to raise_exception(ArgumentError) }
    end

    context "one, string arg" do
      subject { Tengine::Event::Sender.new(@mq_suite).fire("foo") }
      it { should be_kind_of(Tengine::Event) }
      its (:event_type_name) { should == "foo" }
    end

    context "one, event arg" do
      subject { Tengine::Event::Sender.new(@mq_suite).fire(@event) }
      it { should be_kind_of(Tengine::Event) }
      it { should == @event }
    end

    context "event arg + option" do
      subject { Tengine::Event::Sender.new(@mq_suite).fire(@event, :keep_connection => true) }
      it { should == @event }
    end

    context "block argument" do
      before { @event = Tengine::Event.new }
      it "is called" do
        block_called = false
        Tengine::Event::Sender.new(@mq_suite).fire(@event) do
          block_called = true
        end
        block_called.should == true
      end
    end
  end
end
