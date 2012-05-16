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
      value = ERB::Util.html_escape(
        YAML.dump({"username"=>"user"}).sub(/^---( )?(! )?\n?/, ''))
      rendered.should match(/#{Regexp.escape(value)}/)

      # BSON::OrderedHash#to_yamlの結果に不要な情報が入っていない事を確認
      rendered.should_not match(/!map:BSON::OrderedHash/)
    end

    it "編集ボタンが表示される" do
      render

      rendered.should have_link(t("views.links.edit"))
    end

    it "キャンセルリンクが表示される" do
      render

      rendered.should have_link(I18n.t("views.links.back_list"))
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
      value = ERB::Util.html_escape(
        YAML.dump({"username"=>"user"}).sub(/^---( )?(! )?\n?/, ''))
      rendered.should match(/#{Regexp.escape(value)}/)
    end
  end

end
