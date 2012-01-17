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
  シナリオ: [異常系]ジョブのスクリプト実行中にMongodbのプライマリーのプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする

    前提 仮想サーバ"test_server1"のファイル:"~/tengine_job_test.log"が存在しないこと
    もし "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    もし "Tengineコアプロセス"の標準出力からPIDを確認する
    もし "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jobnet1001        |jobnet1001|閲覧 実行|
    

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jobnet1001"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export J1_SLEEP=120"と入力する
    かつ "実行"ボタンをクリックする
    かつ 10秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   もし MongoDBのprimaryプロセスをダウンさせるために"ssh root@#{primary_ip} command \"ps -eo pid -o cmd|grep mongod|grep -v grep| cut -d ' ' -f2|xargs kill\""コマンドを実行する
   かつ 10秒間待機する
   かつ MongoDBのprimaryプロセスがダウンしているか確認するために"ssh root@#{primary_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   ならば MongoDBのprimaryプロセスがダウンしていること

   もし 60秒間待機する
   かつ MongoDBのsecondaryプロセスがprimaryになっていることを"mongo features/step_definitions/mongodb/status.js"コマンドで確認する
   ならば 落としたプロセスの"\"stateStr\" : \"(not reachable/healthy)\""
   ならば 標準出力に"\"stateStr\" : \"PRIMARY\""と表示されていること

   もし 110秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/0004_retry_one_layer.sh|test_server1|test_credential1|2011/11/25 14:43:22|       |正常終了    |          |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jobnet1001         |jobnet1001|        |        |正常終了|監視 再実行|

   もし MongoDBプロセスを起動しなおすために"ssh root@#{primary_ip} command \"mongod --replSet tengine_rs --port 27017 --dbpath /home/tengine/mongo_data/replSet/data --logpath /home/tengine/mongo_data/replSet/tengine.log --fork --logappend --rest --journal\""コマンドを実行する
   かつ MongoDBプロセスが起動していることを確認するために"ssh root@#{primary_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   ならば MongoDBのUNKNOWNプロセスがないこと
   




