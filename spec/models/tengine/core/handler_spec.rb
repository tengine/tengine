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

end
