require 'spec_helper'

describe "Tengine::Core::HandlerPaths" do
  describe "GET /tengine_core_handler_paths" do
    before do
      Tengine::Core::Driver.delete_all
      @driver = Tengine::Core::Driver.create!(name:"driver1", version:"123")
    end

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_core_handler_paths_path
      response.status.should be(200)
    end
  end
end
