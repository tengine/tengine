# -*- coding: utf-8 -*-

require 'spec_helper'

describe "tengine/resource/credentials/index.html.erb" do
  before(:each) do
    assign(:credentials, Kaminari.paginate_array([
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
    ]).page(1))
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

  context "nameの昇順で一覧を表示しているとき" do
    before(:each) do
      @request.query_parameters[:sort] = {"name" => "asc"}
      @request.params[:sort] = {"name" => "asc"}
    end

    it "nameのソートのリンクに降順のクエリーパラメータが付加されていてclassがascになっていること" do
      render

      href = tengine_resource_credentials_path(:sort=>{:name=>"desc"})
      rendered.should have_xpath("//a[@class='asc'][@href='#{href}']",
        :text => Tengine::Resource::Credential.human_attribute_name(:name))
    end

    it "descriptionのソートのリンクに昇順のクエリーパラメータが付加されていてclassが空文字列となっていること" do
      render

      href = tengine_resource_credentials_path(:sort=>{:description=>:asc})
      rendered.should have_xpath("//a[@class=''][@href='#{href}']",
        :text => Tengine::Resource::Credential.human_attribute_name(:description))
    end
  end

  it "検索フォームに値が入っていないこと、セレクトボックスがすべてチェックされていること" do
    render

    assert_select "input[id='finder_name']", :text => "", :count => 1
    assert_select "input[id='finder_description']", :text => "", :count => 1
    assert_select "input[id='finder_auth_type_cd_01'][type = checkbox][value = 1]"
    assert_select "input[id='finder_auth_type_cd_02'][type = checkbox][value = 1]"
    assert_select "input[id='finder_auth_type_cd_03'][type = checkbox][value = 1]"
    
  end

  it "検索ボタンが表示されていること" do
    render

    rendered.should have_button(I18n.t("views.links.search"))
  end

  it "リセットボタンが表示されていること" do
    render

    rendered.should have_xpath(%|//input[@type='reset'][@value='#{I18n.t("views.links.reset")}']|, :count => 1)
  end

  it "ソートのリンクが表示されていること" do
    render

    href = tengine_resource_credentials_path(:sort=>{:name=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::Credential.human_attribute_name(:name))
    href = tengine_resource_credentials_path(:sort=>{:description=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::Credential.human_attribute_name(:description))
    href = tengine_resource_credentials_path(:sort=>{:auth_type_cd=>"asc"})
    rendered.should have_xpath("//a[@class=''][@href='#{href}']",
      :text => Tengine::Resource::Credential.human_attribute_name(:auth_type_cd))
  end

end
