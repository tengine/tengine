require 'spec_helper'

describe "tengine/core/handlers/index.html.erb" do
  before(:each) do
    @driver = assign(:driver, stub_model(Tengine::Core::Driver,
      :name => "driver1", :version => "1234"
    ))
    mock_pagination(assign(:handlers, [
      stub_model(Tengine::Core::Handler,
        :filepath => "Filepath",
        :lineno => 1,
        :event_type_names => ["abc", "123"],
        :filter => {"a"=>"1", "b"=>"2"}
      ),
      stub_model(Tengine::Core::Handler,
        :filepath => "Filepath",
        :lineno => 1,
        :event_type_names => ["abc", "123"],
        :filter => {"a"=>"1", "b"=>"2"}
      )
    ]))
  end

  it "renders a list of tengine_core_handlers" do
    render
     # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Filepath".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "abc,123", :count => 2
  end
end
