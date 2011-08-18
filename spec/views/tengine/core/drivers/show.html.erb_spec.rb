require 'spec_helper'

describe "tengine_core_drivers/show.html.erb" do
  before(:each) do
    @driver = assign(:driver, stub_model(Tengine::Core::Driver,
      :name => "Name",
      :version => "Version",
      :enabled => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
