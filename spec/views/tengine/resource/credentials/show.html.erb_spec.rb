# -*- coding: utf-8 -*-


require 'spec_helper'

describe "tengine/resource/credentials/show.html.erb" do


  describe "SSHパスワード認証のとき" do
    before(:each) do
      Tengine::Resource::Credential.delete_all
      @credential = assign(:credential, stub_model(Tengine::Resource::Credential,
        :name => "Name",
        :description => "Description",
        :auth_type_cd => "01",
        :auth_values => {"username"=>"user", "password"=>"password"}
      ))
    end
  
    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Name/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Description/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/SSHパスワード認証/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"username"=>"user"})))}/)
    end
  end

  describe "SSH公開鍵認証のとき" do
    before(:each) do
      Tengine::Resource::Credential.delete_all
      @credential = assign(:credential, stub_model(Tengine::Resource::Credential,
        :name => "Name2",
        :description => "Description2",
        :auth_type_cd => "02",
        :auth_values => {"username"=>"user", "public_key"=>"aaaaaaaaaa", "passphrase"=>"password"}
      ))
    end
  
    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Name2/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Description2/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/SSH公開鍵認証/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"username"=>"user"})))}/)
    end
  end

  describe "EC2アクセスキー認証のとき" do
    Tengine::Resource::Credential.delete_all
    before(:each) do
      @credential = assign(:credential, stub_model(Tengine::Resource::Credential,
        :name => "Name3",
        :description => "Description3",
        :auth_type_cd => "03",
        :auth_values => {"access_key"=>"user", "secret_access_key"=>"password", "default_resion" => "123"} 
      ))
    end
  
    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Name3/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Description3/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/EC2 アクセスキー認証/)
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/#{Regexp.escape(CGI.escapeHTML(YAML.dump({"access_key"=>"user", "default_resion"=>"123"})))}/)
    end
  end

end
