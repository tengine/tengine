require 'spec_helper'

describe "tengine/job/expansions/edit.html.erb" do
  before(:each) do
    @expansion = assign(:expansion, stub_model(Tengine::Job::Expansion,
      :name => "MyString",
      :server_name => "MyString",
      :credential_name => "MyString",
      :killing_signals => ["abc", "123"],
      :killing_signal_interval => 1
    ))
  end

  it "renders the edit expansion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_job_expansions_path(@expansion), :method => "post" do
      assert_select "input#expansion_name", :name => "expansion[name]"
      assert_select "input#expansion_server_name", :name => "expansion[server_name]"
      assert_select "input#expansion_credential_name", :name => "expansion[credential_name]"
      assert_select "input#expansion_killing_signals_text", :name => "expansion[killing_signals_text]"
      assert_select "input#expansion_killing_signal_interval", :name => "expansion[killing_signal_interval]"
    end
  end
end
