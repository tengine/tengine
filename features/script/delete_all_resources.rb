# -*- coding: utf-8 -*-
require 'pp'

#
# rails runnerスクリプト
# リソース系のデータを全削除します
# Tengine::Resouce::VirtualServer
#
puts "#{Time.new}\tstart\t#{__FILE__}"

Tengine::Resource::VirtualServer.delete_all
puts "#{Time.new}\tTengine::Resource::VirtualServer.delete_all"
Tengine::Resource::PhysicalServer.delete_all
puts "#{Time.new}\tTengine::Resource::PhysicalServer.delete_all"
Tengine::Resource::VirtualServerImage.delete_all
puts "#{Time.new}\tTengine::Resource::VirtualServerImage.delete_all"
Tengine::Resource::VirtualServerType.delete_all
puts "#{Time.new}\tTengine::Resource::VirtualServerType.delete_all"

puts "#{Time.new}\tfinish\t#{__FILE__}"
