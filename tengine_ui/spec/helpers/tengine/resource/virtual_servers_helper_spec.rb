# -*- coding: utf-8 -*-
require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the Tengine::Resource::VirtualServersHelper. For example:
#
# describe Tengine::Resource::VirtualServersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Tengine::Resource::VirtualServersHelper do
  describe "name_link_and_desc" do
    it "link付きで表示すること" do
      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create! name: "pserver1"
      url = edit_tengine_resource_physical_server_url(ps)
      result = helper.name_link_and_desc ps, url:url, delimiter:"<br />"
      result.should == link_to(ps.name, url)

      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create!(
             name: "pserver1", description: "testdesc")
      url = edit_tengine_resource_physical_server_url(ps)
      result = helper.name_link_and_desc ps, url:url, delimiter:"<br />"
      result.should == "#{link_to(ps.name, url)}<br />(#{ps.description})"

      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create!(
             name: "pserver1", description: "testdesc")
      url = edit_tengine_resource_physical_server_url(ps)
      result = helper.name_link_and_desc ps, url:url, delimiter:":"
      result.should == "#{link_to(ps.name, url)}:(#{ps.description})"
    end

    it "linkなしで表示すること" do
      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create! name: "pserver2"
      result = helper.name_link_and_desc ps
      result.should == ps.name

      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create!(
             name: "pserver2", description: "testdesc")
      result = helper.name_link_and_desc ps
      result.should == "#{ps.name}(#{ps.description})"
    end
  end

  describe "image_name_link_and_desc" do
    before do
      Tengine::Resource::Provider.delete_all
      Tengine::Resource::VirtualServer.delete_all
      Tengine::Resource::VirtualServerImage.delete_all
      @pr = Tengine::Resource::Provider.create!(name:"test")
      @vs = Tengine::Resource::VirtualServer.create!(
        provider_id:@pr.id,
        name:"vserver1",
        provided_image_id:"vimagep",
      )
      @vi = Tengine::Resource::VirtualServerImage.create!(
        provider_id:@pr.id,
        name:"vimage1",
        provided_id:"vimagep",
      )
    end

    it "link付きで表示すること" do
      url = edit_tengine_resource_virtual_server_image_url(@vi)
      result = helper.image_name_link_and_desc @vs
      result.should == link_to(@vi.name, url)

      @vi.description = "testdesc"
      @vi.save!
      result = helper.image_name_link_and_desc @vs
      result.should == "#{link_to(@vi.name, url)}(#{@vi.description})"
    end

    it "linkなしで表示すること" do
      result = helper.image_name_link_and_desc @vs, false
      result.should == @vi.name

      @vi.description = "testdesc"
      @vi.save!
      result = helper.image_name_link_and_desc @vs, false
      result.should == "#{@vi.name}(#{@vi.description})"
    end
  end
end
