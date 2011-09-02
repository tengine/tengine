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
      mock_block.should_receive(:call)
      @handler.process_event(mock_event, [mock_block])
    end

    it "should not call block unless match" do
      mock_event = mock(:event)
      mock_event.stub!(:key).and_return("uuid")
      @handler.stub!(:match?).with(mock_event).and_return(false)
      mock_block = lambda{}
      mock_block.should_not_receive(:call)
      @handler.process_event(mock_event, [mock_block])
    end
  end

end
