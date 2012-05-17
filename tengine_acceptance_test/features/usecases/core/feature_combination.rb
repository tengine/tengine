# -*- coding: utf-8 -*-
require 'pp'

class FeatureCombination
  def initialize_features(version)
    features = {
      "DBサービスの起動" => [
        "もし \"DB\"の起動を行うために\"mongod --port 21039 --dbpath ~/tmp/mongodb_test/ --fork --logpath ~/tmp/mongodb_test/mongodb.log  --quiet\"というコマンドを実行する",
        "ならば \"DB\"が起動していること",
      ],
     "DBサービスの停止" => [
       "もし \"DB\"の停止を行うために\"mongo localhost:21039/admin features/step_definitions/mongodb/shutdown.js\"というコマンドを実行する",
       "ならば \"DB\"が停止していること"
     ],
     "Tengineプロセスの起動" => [
       "もし \"Tengineコア\"の起動を行うために\"tengined -k start -f features/support/config/tengine.yml -T ./features/support/dsls/production_environment_change/current\"というコマンドを実行する",
       "ならば \"Tengineコア\"が起動していること"
     ],
     "Tengineプロセスの停止" => [
       "もし \"Tengineコア\"の起動を行うために\"tengined -k stop\"というコマンドを実行する",
       "ならば \"Tengineコア\"が起動していること"
     ],
     "DBパッケージの更新" => [
       "もし DBパッケージをバージョン(.*)から(.*)に更新する",
       "ならば DBパッケージをバージョン(.*)から(.*)に更新されていること"
     ],
     "DBパッケージのロールバック" => [
       "もし DBパッケージをバージョン(.*)から(.*)にロールバックする",
       "ならば DBパッケージをバージョン(.*)から(.*)にロールバックされていること"
     ],
     "Tengineコアパッケージの更新" => [
       "もし Tengineコアパッケージをバージョン(.*)から(.*)に更新する",
       "ならば Tengineコアパッケージをバージョン(.*)から(.*)に更新されていること"
     ],
     "Tengineコアパッケージのロールバック" => [
       "もし Tengineコアパッケージをバージョン(.*)から(.*)にロールバックする",
       "ならば Tengineコアパッケージがバージョン(.*)で起動していること"
     ],
     "DBのリストア" => [
       "もし DBのリストアをする",
       "ならば DBがリストアされていること"
     ],
     "DBのリストア(物理ファイル)" => [
       "もし DBを\"tmp/end_to_end_test/backupdb/\"から物理リストアする",
       "ならば DBが物理リストアされていること"
     ],
     "DBのバックアップ(物理ファイル)" => [
       "もし DBを\"tmp/end_to_end_test/backupdb/\"から物理バックアップする",
       "ならば \"tmp/end_to_end_test/backupdb/\"にDBの物理バックアップファイルが存在すること"
     ],
     "DBのリカバリ" => [
       "もし DBのリカバリをする",
       "ならば DBのリカバリがされていること"
     ],
     "DBのマイグレーション" => [
       "もし DBのマイグレーションをする",
       "ならば DBのマイグレーションがされていること"
     ],
     "DBのロールバック" => [
       "もし DBのロールバックをする",
       "ならば DBのロールバックがされていること"
     ],
     "イベントドライバの無効化" => [
       "もし \"イベントドライバ一覧画面\"を表示する",
       "ならば \"イベントドライバ一覧画面\"を表示していること",
       "かつ 以下の行が表示されること",
       "|  driver70  |#{version}|有効|",
       "",
       "もし \"無効\"ボタンをクリックする",
       "ならば \"イベントドライバ一覧画面\"を表示していること",
       "かつ 以下の行が表示されること",
       "|  driver70  |#{version}|無効|"
     ],
     "イベントドライバの有効化" => [
       "もし \"イベントドライバ一覧画面\"を表示する",
       "ならば \"イベントドライバ一覧画面\"を表示していること",
       "かつ 以下の行が表示されること",
       "|  driver71  |#{version}|無効|",
       "",
       "もし \"有効\"ボタンをクリックする",
       "ならば \"イベントドライバ一覧画面\"を表示していること",
       "かつ 以下の行が表示されること",
       "|  driver71  |#{version}|有効|"
     ],
     "イベントハンドラ定義のデプロイ" => [
       "もし イベントハンドラ定義のデプロイをする",
       "ならば イベントハンドラ定義のデプロイがされること",
       "",
       "もし \"イベントハンドラ一覧画面\"を表示する",
       "ならば \"イベントドライバ一覧画面\"を表示していること",
       "かつ 以下の行が表示されること",
       "|  driver70  |#{version}|有効|",
       "|  driver71  |#{version}|無効|",
     ],
     "イベントハンドラ定義のロールバック" => [
       "もし イベントハンドラ定義のロールバックをする",
       "ならば イベントハンドラ定義のロールバックがされること",
       "",
       "もし \"イベントハンドラ一覧画面\"を表示する",
       "ならば \"イベントドライバ一覧画面\"を表示していること",
       "かつ 以下の行が表示されること",
       "|  driver70  |#{version}|有効|",
       "|  driver71  |#{version}|無効|",
     ]
    }
  end
  
  def translate_usecase_to_feature(usecase,step)
    version = 2
    version = 3 if usecase.include?("イベントハンドラ定義のデプロイ")
    version = 1 if usecase.include?("イベントハンドラ定義のロールバック")
    features = initialize_features(version)
    # 前後の依存関係
    features[step]
  end

  def prerequisite(usecase)
    prerequisites = []
    start_db = usecase.include?("DBサービスの起動")
    stop_db = usecase.include?("DBサービスの停止")
    if start_db && stop_db
      prerequisites << "\"DB\"が起動している"
    elsif start_db 
      prerequisites << "\"DB\"が停止している"
    end
    start_tengine = usecase.include?("Tengineプロセスの起動")
    stop_tengine = usecase.include?("Tengineプロセスの停止")
    if start_tengine && stop_tengine
      prerequisites << "\"Tengineコア\"が起動している"
    else start_tengine
      prerequisites << "\"Tengineコア\"が停止している"
    end
    do_db_update = usecase.include?("DBパッケージの更新")
    do_db_rollback = usecase.include?("DBパッケージのロールバック")
    if do_db_update
      prerequisites << "DBパッケージがバージョン2.5.1で起動している" #更新
    elsif do_db_rollback
      prerequisites << "DBパッケージがバージョン2.6.0で起動している" #ロールバッ
    end
    do_tengine_update = usecase.include?("Tengineコアパッケージの更新")
    do_tengine_rollback = usecase.include?("Tengineコアパッケージのロールバック")
    if do_tengine_update
      prerequisites << "Tengineコアパッケージがバージョン\"A\"で起動している"
    elsif do_tengine_rollback
      prerequisites << "Tengineコアパッケージがバージョン\"B\"で起動している"
    end
    do_recovery_file = usecase.include?("DBのリカバリ(物理)")
    prerequisites << "\"tmp/end_to_end_test/backupdb/\"にDBの物理バックアップファイルが存在する" if do_recovery_file
    do_recovery = usecase.include?("DBのリカバリ")
    prerequisites << "\"tmp/end_to_end_test/backupdb/\"にDBのバックアップファイルが存在する" if do_recovery

    event_handler_deploy = usecase.include?("イベントハンドラ定義のデプロイ")
    event_handler_rollback = usecase.include?("イベントハンドラ定義のロールバック")
    prerequisites << "2バージョンのイベントハンドラ定義がイベントハンドラストアに登録されている" if event_handler_deploy || event_handler_rollback 


   prerequisites
  end
  def is_package_version_change()
    
  end
end

fc = FeatureCombination.new
steps = fc.translate_usecase_to_feature([],"DBパッケージの更新")

steps.each do |step|
  puts step
end
puts "-----------------"
prerequisites = fc.prerequisite(["Tengineコアパッケージの更新","Tengineプロセスの起動"])

puts "前提 #{prerequisites.shift}" unless prerequisites.empty? 
prerequisites.each do |prerequisite|
  puts "かつ #{prerequisite}"
end
