require 'spec_helper'

describe "Tengine::Test::Scripts" do
  describe "GET /tengine_test_scripts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_test_scripts_path
      response.status.should be(200)
    end
  end
end
