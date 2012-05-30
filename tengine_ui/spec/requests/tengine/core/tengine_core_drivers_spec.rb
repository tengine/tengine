require 'spec_helper'

describe "Tengine::Core::Drivers" do
  describe "GET /tengine_core_drivers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_core_drivers_path
      response.status.should be(200)
    end
  end
end
