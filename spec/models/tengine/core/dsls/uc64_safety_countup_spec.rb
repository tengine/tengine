# -*- coding: utf-8 -*-
require 'spec_helper'

describe "uc64_safety_countup" do
  before do
    Tengine::Core::Driver.delete_all
    Tengine::Core::Session.delete_all
    config = Tengine::Core::Config.new({
        :tengined => {
          :load_path => File.expand_path('../../../../../examples/uc64_safety_countup.rb', File.dirname(__FILE__)),
        },
      })
    @bootstrap = Tengine::Core::Bootstrap.new(config)
    @bootstrap.load_dsl
    @kernel1 = Tengine::Core::Kernel.new(config)
    @kernel2 = Tengine::Core::Kernel.new(config)
  end

  it "ロード後にはsessionに値が入っている" do
    driver64 = Tengine::Core::Driver.first
    session = driver64.session
    session.should_not be_nil
    session.properties.should == { 'foo' => 100}
    @kernel1.bind
    @kernel2.bind
    mock_headers = mock(:headers)
    mock_headers.should_receive(:ack).twice
    raw_event1 = Tengine::Event.new(:event_type_name => "event64")
    raw_event2 = Tengine::Event.new(:event_type_name => "event64")

    test_session_wrapper_class = Class.new(Tengine::Core::SessionWrapper) do
      def __get_properties__(*args)
        result = super
        Fiber.yield
        result
      end
    end

    f1 = Fiber.new{
      session_wrapper1 = test_session_wrapper_class.new(Tengine::Core::Session.find(session.id))
      @kernel1.dsl_env.should_receive(:session).and_return(session_wrapper1)
      @kernel1.process_message(mock_headers, raw_event1.to_json)
    }
    f1.resume

    f2 = Fiber.new{
      session_wrapper2 = test_session_wrapper_class.new(Tengine::Core::Session.find(session.id))
      @kernel2.dsl_env.should_receive(:session).and_return(session_wrapper2)
      @kernel2.process_message(mock_headers, raw_event2.to_json)
    }
    f2.resume

    f1.resume
    session.reload
    session.properties.should == { 'foo' => 101}

    f2.resume
    session.reload
    session.properties.should == { 'foo' => 101}

    f2.resume
    session.reload
    session.properties.should == { 'foo' => 102}
  end

end
