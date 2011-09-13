require 'spec_helper'

describe Tengine::Core::EventIgnitionsController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'fire'" do
    it "should be successful" do
      Kernel.stub(:system).and_return(true)
      post :fire, :event => {event_type_name: "event01"}
      response.should redirect_to(tengine_core_event_ignitions_new_path)
    end
  end

end
