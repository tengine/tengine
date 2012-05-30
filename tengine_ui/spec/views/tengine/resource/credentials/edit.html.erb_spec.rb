# -*- coding: utf-8 -*-

require 'spec_helper'

describe "tengine/resource/credentials/edit.html.erb" do


  describe "SSH パスワード認証を選択したとき" do

    before(:each) do
      @credential = assign(:credential, stub_model(Tengine::Resource::Credential,
        :name => "MyString",
        :description => "MyString",
        :auth_type_cd => "01",
        :auth_values => {"username"=>"11111", "password"=>"2"}
      ))
    end
 
    it "SSHパスワード認証に必要な情報が作成されていること" do
      render

      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form", :action => tengine_resource_credentials_path(@credential), :method => "post" do
        assert_select "input#credential_name", :name => "credential[name]"
        assert_select "input#credential_description", :name => "credential[description]"
        assert_select "select#credential_auth_type_cd", :name => "credential[auth_type_cd]"
        assert_select "input#credential_auth_values_password", :name => "credential[auth_values][password]"
        assert_select "input#credential_auth_values_username", :name => "credential[auth_values][username]"
      end

      rendered.should have_xpath("//input[@type='submit'][@class='BtnNext']")
    end
  end

  describe "SSH パスワード認証を選択したとき" do

    before(:each) do
      @credential = assign(:credential, stub_model(Tengine::Resource::Credential,
        :name => "MyString",
        :description => "MyString",
        :auth_type_cd => "02",
        :auth_values => {"username"=>"1111111", "private_keys"=>"22222","passphrase" => "bbbbbbbbb" }
      ))
    end
 
    it "SSHパスワード認証に必要な情報が作成されていること" do
      render

      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form", :action => tengine_resource_credentials_path(@credential), :method => "post" do
        assert_select "input#credential_name", :name => "credential[name]"
        assert_select "input#credential_description", :name => "credential[description]"
        assert_select "select#credential_auth_type_cd", :name => "credential[auth_type_cd]"
        assert_select "input#credential_auth_values_username", :name => "credential[auth_values][username]"
        assert_select "textarea#credential_auth_values_private_keys", :name => "credential[auth_values][private_keys]"
        assert_select "input#credential_auth_values_passphrase", :name => "credential[auth_values][passphrase]"
      end
    end
  end

end
