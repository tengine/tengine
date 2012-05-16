require 'spec_helper'

describe "Tengine::Resource::Credentials" do
  describe "GET /tengine_resource_credentials" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_resource_credentials_path
      response.status.should be(200)
    end
  end
end
