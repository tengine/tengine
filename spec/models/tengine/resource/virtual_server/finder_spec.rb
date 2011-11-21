# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Resource::VirtualServer::Finder do
  it "初期化時はnilが入っていること" do
    finder = Tengine::Resource::VirtualServer::Finder.new

    finder.attributes do |attr_name|
      finder.send(attr_name).should == nil
    end

    finder = Tengine::Resource::VirtualServer::Finder.new(finder:{})

    finder.attributes do |attr_name|
      finder.send(attr_name).should == nil
    end
  end
end
