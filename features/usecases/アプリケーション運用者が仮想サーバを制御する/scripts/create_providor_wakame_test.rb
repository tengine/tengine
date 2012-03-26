# -*- coding: utf-8 -*-
require 'pp'

#
# rails runnerスクリプト
# TamaのテストモードをTengineで使用するためにTengine::Resource::Provider::Wakameのconnection_settingsに値を設定する
#
puts "#{Time.new}\tstart\t#{__FILE__}"

# テスト用のjsonファイルを格納しているディレクトリ
test_files_dir = File.expand_path(ARGV[0] || "features/usecases/アプリケーション運用者が仮想サーバを制御する/test_files")
puts "test_files_dir: #{test_files_dir}"

Tengine::Resource::Provider::Wakame.delete_all
puts "#{Time.new}\tTengine::Resource::Provider::Wakame.delete_all"
tama_test = Tengine::Resource::Provider::Wakame.create(
  :name => "tama_test_001",
  :connection_settings => {
    :test => true,
    :options => {
      :describe_instances_file      => File.expand_path('describe_instances.json',      test_files_dir), # 仮想サーバの状態
      :describe_images_file         => File.expand_path('describe_images.json',         test_files_dir), # 仮想サーバイメージの状態
      :run_instances_file           => File.expand_path('run_instances.json',           test_files_dir), # 仮想サーバ起動時
      :terminate_instances_file     => File.expand_path('terminate_instances.json',     test_files_dir), # 仮想サーバ停止時
      :describe_host_nodes_file     => File.expand_path('describe_host_nodes.json',     test_files_dir), # 物理サーバの状態
      :describe_instance_specs_file => File.expand_path('describe_instance_specs.json', test_files_dir)  # 仮想サーバスペックの状態
    }
  }
)
puts "#{Time.new}\tTengine::Resource::Provider::Wakame.create"
pp tama_test.connection_settings[:options]

puts "#{Time.new}\tfinish\t#{__FILE__}"
