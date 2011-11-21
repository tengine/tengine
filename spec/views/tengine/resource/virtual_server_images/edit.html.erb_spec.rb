# -*- coding: utf-8 -*-
require 'spec_helper'

describe "tengine/resource/virtual_server_images/edit.html.erb" do
  before(:each) do
    @virtual_server_image = assign(:virtual_server_image, stub_model(Tengine::Resource::VirtualServerImage,
      :name => "virtual_image",
      :description => "users description virtual image.",
      :provided_id => "abcdef",
      :provided_description => "virtual image large size."
    ))
  end

  it "renders the edit virtual_server_image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_resource_virtual_server_images_path(@virtual_server_image), :method => "post" do
      rendered.should match(/virtual_image/)
      rendered.should match(/abcdef/)
      rendered.should match(/virtual image large .../)
      assert_select "textarea#virtual_server_image_description", :name => "virtual_server_image[description]"
    end
  end

  it "更新ボタンが表示されていること" do
    render

    rendered.should have_button(I18n.t("views.links.update"))
  end

  it "キャンセルボタンが表示されていること" do
    render

    rendered.should have_button(I18n.t("cancel"))
  end

end
