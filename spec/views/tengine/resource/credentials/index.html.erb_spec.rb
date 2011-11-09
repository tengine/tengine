# -*- coding: utf-8 -*-

=begin
require 'spec_helper'

describe "tengine/resource/credentials/index.html.erb" do
  before(:each) do
    mock_pagination(assign(:credentials, [
      stub_model(Tengine::Resource::Credential,
        :id=>BSON::ObjectId("4eb6a247df46903c8600007b"),
        :name => "ssh_password",
        :description => "Description",
        :auth_type_cd => "01",
        :auth_values => {"username"=>"1", "password"=>"2"},
        :created_at => Time.now ,
        :updated_at => Time.now
      ),
      stub_model(Tengine::Resource::Credential,
        :id=>BSON::ObjectId('4eb79ed8be074a4282000002'),
        :name => "ssh_public_key",
        :description => "Description",
        :auth_type_cd => "02",
        :auth_values => {"username"=>"1", "private_keys"=>"2", "passphrase" => 3},
        :created_at => Time.now,
        :updated_at => Time.now
      ),
      stub_model(Tengine::Resource::Credential,
        :id=>BSON::ObjectId('4eb7a7a5be074a4282000003'),
        :name => "ec2_access_key",
        :description => "Description",
        :auth_type_cd => "03",
        :auth_values => {"access_key"=>"1", "secret_access_key"=>"2", "default_region" => 3},
        :created_at => Time.now,
        :updated_at => Time.now
      )
    ]))
  end

  it "renders a list of tengine_resource_credentials" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "ssh_password".to_s, :count => 1
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 3
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "SSHパスワード認証".to_s, :count => 1
  end


  it "nameのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_resource_credentials_path(:sort=>{:name=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::Credential.human_attribute_name(:name))
  end

  it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_resource_credentials_path(:sort=>{:description=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::Credential.human_attribute_name(:description))
  end

  it "auth_type_cdのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
    render

    href = tengine_resource_credentials_path(:sort=>{:auth_type_cd=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::Credential.human_attribute_name(:auth_type_cd))
  end





=end
