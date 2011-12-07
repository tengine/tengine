# -*- coding: utf-8 -*-
require 'pp'

#
# rails runnerスクリプト
# TamaをTengineで使用するためにTengine::Resource::Provider::Wakameのconnection_settingsに値を設定する
#
puts "#{Time.new}\tstart\t#{__FILE__}"

# Wakame用の接続設定用の変数
connection_settings = {
  :account => 'a-zzzzzzxx',
  :ec2_host => '127.0.0.1',
  :ec2_port => '9005',
  :ec2_protocol => 'http',
  :wakame_host => '127.0.0.1',
  :wakame_port => '9001',
  :wakame_protocol => 'http'
}

Tengine::Resource::Provider::Wakame.delete_all
puts "#{Time.new}\tTengine::Resource::Provider::Wakame.delete_all"
tama_real = Tengine::Resource::Provider::Wakame.create!(
  :name => 'Wakame',
  :connection_settings => connection_settings,
  :properties => {
    :key_name => 'ssh-hadoop01'
  })
puts "#{Time.new}\tTengine::Resource::Provider::Wakame.create"
pp tama_real.connection_settings[:options]

puts "#{Time.new}\tfinish\t#{__FILE__}"
