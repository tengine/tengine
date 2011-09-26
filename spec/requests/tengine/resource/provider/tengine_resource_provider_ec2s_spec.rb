require 'spec_helper'

describe "Tengine::Resource::Provider::Ec2s" do
  describe "GET /tengine_resource_provider_ec2s" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tengine_resource_provider_ec2s_path
      response.status.should be(200)
    end
  end
end
