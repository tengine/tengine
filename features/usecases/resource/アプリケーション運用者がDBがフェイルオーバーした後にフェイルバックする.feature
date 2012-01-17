#language:ja
機能: アプリケーション運用者がDBがフェイルオーバーした後にフェイルバックする

  DBがダウンした際に、
  アプリケーション運用者
  は、フェイルオーバーしていることを確認した後、フェイルバックを行いたい

  背景:DBプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする
    前提 "DBプロセス"が起動している
    かつ "キュープロセス"が起動している
    かつ "Tengineコンソールプロセス"が起動している
    かつ テンプレートジョブが1件も登録されていない
    かつ 実行ジョブが1件もない
    かつ イベントが1件もない
    かつ 仮想サーバがインスタンス識別子:"test_server1"で登録されていること
    かつ 認証情報が名称:"test_credential1"で登録されている
    かつ イベントキューにメッセージが1件もない
# $ bundle exec irb -rmongoid
# > Mongoid.load!("path/to/your/mongoid.yml")
# > db = Mongoid.config.database
# > db.connection.primary
    かつ mongodbのprimaryサーバのIPが確認できている

  @success
  @1000
  シナリオ: [異常系]仮想マシンの起動中にMongodbのプライマリーのプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし "仮想サーバ一覧画面"を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|仮想サーバは起動していません。|||||||

    もし"仮想サーバ起動"ボタンをクリックする
    ならば "仮想サーバ起動"画面が表示されていること
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    ならば "起動可能数"を確認する # 後に実行する仮想サーバ起動の後に起動可能数が増加することを確認します

    もし "仮想サーバ名"に"run_virtual_servers"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に1を選択する
    かつ "説明"に"仮想サーバを1台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば tengine_console のログに以下の文言が表示されること
    """
    Tama::Controllers::TamaController#run_instances("virtual_server_image_uuid_01", 1, 1, [], nil, "", nil, "virtual_server_spec_uuid_01", nil, nil, "physical_server_uuid_01", nil)
    """
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    virtual_server_uuid_01
    もし "閉じる"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること

    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがrunningになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_1_virtual_servers001|virtual_server_uuid_01|仮想サーバを1台起動テストの説明|private_ip_address: 192.168.1.1|starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

   もし MongoDBのprimaryプロセスをダウンさせるために"ssh root@#{primary_ip} command \"ps -eo pid -o cmd|grep mongod|grep -v grep| cut -d ' ' -f2|xargs kill\""コマンドを実行する
   かつ 10秒間待機する
   かつ MongoDBのprimaryプロセスがダウンしているか確認するために"ssh root@#{primary_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   ならば MongoDBのprimaryプロセスがダウンしていること

   もし 20秒間待機する
   かつ MongoDBのsecondaryプロセスがprimaryになっていることを"mongo features/step_definitions/mongodb/status.js"コマンドで確認する
   ならば 標準出力に"\"stateStr\" : \"PRIMARY\""と表示されていること

   もし 120秒間待機する
   かつ "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがrunningになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_1_virtual_servers001|virtual_server_uuid_01|仮想サーバを1台起動テストの説明|private_ip_address: 192.168.1.1|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

   もし MongoDBプロセスを起動しなおすために"ssh root@#{primary_ip} command \"mongod --replSet tengine_rs --port 27017 --dbpath /home/tengine/mongo_data/replSet/data --logpath /home/tengine/mongo_data/replSet/tengine.log --fork --logappend --rest --journal\""コマンドを実行する
   かつ MongoDBプロセスが起動していることを確認するために"ssh root@#{primary_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   ならば MongoDBのUNKNOWNプロセスがないこと
