# -*- coding: utf-8 -*-

begin

require 'cucumber/rake/task'


DESCRIPTION_PREFIX = "End to End Test"
FEATURES = [
  { key: "01",
    name: "#{DESCRIPTION_PREFIX} {アプリケーション運用者がイベント通知画面で問題を知る}",
    path: "コア/アプリケーション運用者がイベント通知画面で問題を知る.feature" },
  { key: "02",
    name: "#{DESCRIPTION_PREFIX} {アプリケーション開発者がTengineコアを運用に耐えれるか検証する}",
    path: "コア/アプリケーション開発者がTengineコアを運用に耐えれるか検証する.feature" },
  { key: "03",
    name: "#{DESCRIPTION_PREFIX} {アプリケーション開発者がイベントハンドラ定義を作成する}",
    path: "コア/アプリケーション開発者がイベントハンドラ定義を作成する.feature" },
  { key: "04",
    name: "#{DESCRIPTION_PREFIX} {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる}",
    path: "コア/アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる" },
  { key: "04:01",
    name: "#{DESCRIPTION_PREFIX} {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる} アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる.feature",
    path: "コア/アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる/アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる.feature"},
  { key: "04:02",
    name: "#{DESCRIPTION_PREFIX} {アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる} アプリケーション開発者がいろんなパターンのイベントハンドラ定義を試してみる.feature",
    path: "コア/アプリケーション開発者がTengineコアのイベントハンドラ定義を試してみる/アプリケーション開発者がいろんなパターンのイベントハンドラ定義を試してみる.feature" },


  { key: "05",
    name: "#{DESCRIPTION_PREFIX} {アプリケーション開発者が開発環境へインストールする}",
    path: "コア/アプリケーション開発者が開発環境へインストールする" },
]

E2E_OPTS = ["--format", "junit", "--out", "tmp/end_to_end_test_reports", "--strict", "--tags", "~@wip", "--tags", "~@manual", "--tags", "~@pending", "-r", "features"]

FEATURE_DIR = "features/usecases"

FEATURES.each do |f|
  Cucumber::Rake::Task.new("end_to_end_test:#{f[:key]}", f[:name]) do |task|
    feature_file = "#{FEATURE_DIR}/#{f[:path]}"
    task.cucumber_opts = E2E_OPTS + [feature_file]
  end
end

rescue LoadError
  desc 'end_to_end_test rake task not available (cucumber not installed)'
  task :end_to_end_test do
    abort 'end_to_end_test rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
