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
      result = helper.name_link_and_desc ps
      url = tengine_resource_physical_server_url(ps)
      result.should == link_to("pserver1", url)

      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create! name: "pserver1", description: "testdesc"
      result = helper.name_link_and_desc ps
      url = tengine_resource_physical_server_url(ps)
      result.should == "#{link_to("pserver1", url)}<br />(#{ps.description})"
    end

    it "linkなしで表示すること" do
      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create! name: "pserver2"
      result = helper.name_link_and_desc ps, false
      result.should == "pserver2"

      Tengine::Resource::PhysicalServer.delete_all
      ps = Tengine::Resource::PhysicalServer.create! name: "pserver2", description: "testdesc"
      result = helper.name_link_and_desc ps, false
      result.should == "pserver2<br />(#{ps.description})"
    end
  end

  describe "image_name_link_and_desc" do
    it "link付きで表示すること" do
    end

    it "linkなしで表示すること" do
    end
  end
end
