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
    かつ 仮想サーバがインスタンス識別子:"test_server1"で登録されていること
    かつ 認証情報が名称:"test_credential1"で登録されている
    かつ イベントキューにメッセージが1件もない
    かつ Replica Setsを設定したMongoDBが3台のサーバで動作していること
    かつ Replica SetsのPRIMARYノードで動作しているmongodプロセスをmongod_pと呼ぶ
    かつ Replica SetsのSECONDARYノードで動作しているmongodプロセスをmongod_s1, mongod_s2と呼ぶ
    かつ mongod_pが動作しているサーバのIPをmongod_p_ipと呼ぶ
    かつ mongod_s1が動作しているサーバのIPをmongod_s1_ipと呼ぶ
    かつ mongod_s2が動作しているサーバのIPをmongod_s2_ipと呼ぶ
# $ bundle exec irb -rmongoid
# > Mongoid.load!("path/to/your/mongoid.yml")
# > db = Mongoid.config.database
# > db.connection.primary
    かつ resource_watchdが動作しているサーバのIPを"resource_watchd_ip"と呼ぶ
    かつ heartbeat_watchdが動作しているサーバのIPを"heartbeat_watchd_ip"と呼ぶ
    かつ atdが動作しているサーバのIPを"atd_ip"と呼ぶ

# --------------------------

# rs.statusの確認用のstateとstateStrの一覧
#
# |state|stateStr                                                   |
# |0    |Starting up, phase 1 (parsing configuration)               |
# |1    |Primary                                                    |
# |2    |Secondary                                                  |
# |3    |Recovering (initial syncing, post-rollback, stale members) |
# |4    |Fatal error                                                |
# |5    |Starting up, phase 2 (forking threads)                     |
# |6    |Unknown state (member has never been reached)              |
# |7    |Arbiter                                                    |
# |8    |Down                                                       |　　#仕様としては、左記となっていますが実装では「(not reachable/healthy)」と表示されます。
# |9    |Rollback                                                   |
#
# --------------------------


  @success
  @1000
  シナリオ: [異常系]ジョブのスクリプト実行中にMongoDBのプライマリーのプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする

    前提 仮想サーバ"test_server1"のジョブ実行ユーザのホームディレクトリにファイル:"tengine_job_test.log"が存在しないこと
    もし "tengined"の設定ファイル"config/tengined.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
    かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する
    #2プロセス起動します
    かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    かつ "Tengineコアプロセス"の標準出力からPIDを確認する
    かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

    かつ "tengine_heartbeat_watchd"の設定ファイル"config/heartbeat_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
    かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する
    #2プロセス起動します
    かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する

    かつ "tengine_atd"の設定ファイル"config/atd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
    かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する
    #2プロセス起動します
    かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する

    かつ "tengine_resouce_watchd"の設定ファイル"config/resouce_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
    かつ "tengine_resource_watchd"の起動行うために"tengine_resource_watchd -f config/resource_watchd.yml.erb"というコマンドを実行する

    かつ "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jobnet1001        |jobnet1001|閲覧 実行|
    

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jobnet1001"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export SLEEP=120"と入力する
# SLEEPの時間は、MongoDBがフェールオーバする時間を考慮して長めにしていますが、実際にテストはしていないため、この長さでも短い可能性があります
# もし、connect failureとエラーが出力された場合は、SLEEP時間を長く設定して下さい。おおよそ、この時間で問題ないという値がわかれば、このfeatureを編集してSLEEPの値を変更し、このコメントを削除して下さい。
    かつ "実行"ボタンをクリックする
    かつ 10秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   もし mongod_pをダウンさせるために"ssh root@#{mongod_p_ip} command \"ps -eo pid,command|grep mongod|grep -v grep| cut -d ' ' -f2|xargs kill -9\""コマンドを実行する
   かつ 10秒間待機する
   かつ mongod_pがダウンしているか確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   ならば mongod_pがダウンしていること

   もし 60秒間待機する
   かつ mongo_s1,mongod_s2のいずれかにスクリプトをコピーするために"scp tengine_console/features/step_definitions/mongodb/status.js root@#{mongod_s1_ip}:"コマンドを実行する
   かつ mongod_s1,mongod_s2のいずれかがPRIMARYになっていることを確認するために"ssh root@#{mongod_s1_ip} command \"mongo status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"(not reachable/healthy)"と表示されていること
   ならば mongod_s1,mongod_s2のいずれかの"stateStr"が"PRIMARY"と表示されていること

   もし 50秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |正常終了    |          |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明      |開始日時  |終了日時 |ステータス|操作       |
    |  |jobnet1001  |jobnet1001|        |        |正常終了  |監視 再実行|

   かつ tengine_resource_watchdプロセスが起動していることを確認するために"ssh root@#{resource_watchd_ip} command \"ps aux|grep tengine_resource_watchd|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   ならば tengine_resource_watchdプロセスが起動していること

   かつ tengine_heartbeat_watchdプロセスが起動していることを確認するために"ssh root@#{heartbeat_watchd_ip} command \"ps aux|grep tengine_heartbeat_watchd|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   ならば tengine_heartbeat_watchdプロセスが起動していること

   もし tengine_atdプロセスが起動していることを確認するために"ssh root@#{atd_ip} command \"ps aux|grep tengine_atd|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   ならば tengine_atdプロセスが起動していること

   もし mongod_pを起動しなおすために"ssh root@#{mongod_p_ip} command \"mongod --replSet tengine_rs --port 27017 --dbpath /home/tengine/mongo_data/replSet/data --logpath /home/tengine/mongo_data/replSet/tengine.log --fork --logappend --rest --journal\""コマンドを実行する
   かつ mongod_pが起動していることを確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   かつ mongod_pがSECONDARYになっていることを確認するために"ssh root@#{mongod_p_ip} command \"mongo features/step_definitions/mongodb/status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"SECONDARY"と表示されていること


# DBがフェイルオーバーしたとしてもtengine_atdが正常に動作しているか検証する
    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jobnet1001"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export SLEEP=90"と入力する
    かつ "強制停止設定"に1と入力する
    かつ "実行"ボタンをクリックする
    かつ 10秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   もし 60秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |タイムアウト強制停止済    |          |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明      |開始日時  |終了日時 |ステータス|操作       |
    |  |jobnet1001  |jobnet1001|        |        |タイムアウト強制停止済  |監視 再実行|

#　DBがフェイルオーバーしたとしてもtengine_heartbeat_watchdが正常に動作しているか検証する

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jobnet1001"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "ジョブネット実行設定画面"を表示する
    かつ "事前実行コマンド"に"export SLEEP=60"と入力する
    かつ "実行"ボタンをクリックする
    かつ 10秒間待機する
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   もし 10秒間待機する
   もし tengine_job_agent_watchdogをダウンさせるために"ssh root@#{job_server_ip} command \"ps -eo pid,command|grep tengine_job_agent_watchdog|grep -v grep| cut -d ' ' -f2|xargs kill -9\""コマンドを実行する
   かつ tengine_job_agent_watchdogがダウンしているか確認するために"ssh root@#{job_server_i} command \"ps aux|grep tengine_job_agent_watchdog|grep -v grep\""コマンドを実行する
   ならば tengine_job_agent_watchdogがダウンしていること

   もし 60秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |状態不明    |          |表示 ステータス変更 |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ID|ジョブネット名|説明  |開始日時|終了日時|ステータス            |操作       |
    |  |jobnet1001         |jobnet1001|        |        |実行中|監視 再実行|




  シナリオ: ジョブ実行前にMongoDBのプライマリーのプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする

   前提 仮想サーバ"test_server1"のジョブ実行ユーザのホームディレクトリにファイル:"tengine_job_test.log"が存在しないこと
   もし "tengined"の設定ファイル"config/tengined.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
   かつ "Tengineコアプロセス"の標準出力からPIDを確認する
   かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する
   #2プロセス起動します
   かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
   かつ "Tengineコアプロセス"の標準出力からPIDを確認する
   かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

   かつ "tengine_heartbeat_watchd"の設定ファイル"config/heartbeat_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する
   #2プロセス起動します
   かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する

   かつ "tengine_atd"の設定ファイル"config/atd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する
   #2プロセス起動します
   かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する

   かつ "tengine_resouce_watchd"の設定ファイル"config/resouce_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_resource_watchd"の起動行うために"tengine_resource_watchd -f config/resource_watchd.yml.erb"というコマンドを実行する

   かつ "テンプレートジョブ一覧画面"を表示する
   ならば "テンプレートジョブ一覧画面"を表示していること
   かつ 以下の行が表示されていること
   |ジョブネット名|説明  |操作     |
   |jobnet1001        |jobnet1001|閲覧 実行|
    

   もし "テンプレートジョブ一覧画面"を表示する
   かつ "jobnet1001"の"実行"リンクをクリックする
   ならば "ジョブネット実行設定画面"を表示していること

   もし "ジョブネット実行設定画面"を表示する
   かつ "事前実行コマンド"に"export SLEEP=60"と入力する
   # SLEEPの時間は、MongoDBがフェールオーバする時間を考慮して長めにしていますが、実際にテストはしていないため、この長さでも短い可能性があります
   # もし、connect failureとエラーが出力された場合は、SLEEP時間を長く設定して下さい。おおよそ、この時間で問題ないという値がわかれば、このfeatureを編集してSLEEPの値を変更し、このコメントを削除して下さい。
   ならば ジョブはまだ実行されていないこと

   # MongoDBのプライマリーのプロセスを停止/停止確認をする
   もし mongod_pをダウンさせるために"ssh root@#{mongod_p_ip} command \"ps -eo pid,command|grep mongod|grep -v grep| cut -d ' ' -f2|xargs kill -9\""コマンドを実行する
   かつ 10秒間待機する
   かつ mongod_pがダウンしているか確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   ならば mongod_pがダウンしていること

   # ジョブを実行する
   もし "実行"ボタンをクリックする
   ならば "ジョブネット監視画面"を表示していること
   かつ 以下の行が表示されていること
   |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
   |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   # ジョブが正常終了することを確認する
   もし 50秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |正常終了    |          |表示 再実行  |

   # フェイルオーバできることの確認
   もし  mongod_s1,mongod_s2のいずれかがPRIMARYになっていることを確認するために"ssh root@#{mongod_s1_ip} command \"mongo status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"(not reachable/healthy)"と表示されていること
   ならば mongod_s1,mongod_s2のいずれかの"stateStr"が"PRIMARY"と表示されていること

   # 停止したDBプロセスをフェイルバックする
   もし mongod_pを起動しなおすために"ssh root@#{mongod_p_ip} command \"mongod --replSet tengine_rs --port 27017 --dbpath /home/tengine/mongo_data/replSet/data --logpath /home/tengine/mongo_data/replSet/tengine.log --fork --logappend --rest --journal\""コマンドを実行する
   かつ mongod_pが起動していることを確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   かつ mongod_pがSECONDARYになっていることを確認するために"ssh root@#{mongod_p_ip} command \"mongo features/step_definitions/mongodb/status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"SECONDARY"と表示されていること



  シナリオ: MongoDBのプライマリーのプロセスがダウンした際にフェールオーバーした際に、ジョブを実行しジョブのスクリプト実行中に強制停止をし、その後アプリケーション運用者がDBプロセスをフェールバックする

   前提 仮想サーバ"test_server1"のジョブ実行ユーザのホームディレクトリにファイル:"tengine_job_test.log"が存在しないこと
   もし "tengined"の設定ファイル"config/tengined.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
   かつ "Tengineコアプロセス"の標準出力からPIDを確認する
   かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する
   #2プロセス起動します
   かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
   かつ "Tengineコアプロセス"の標準出力からPIDを確認する
   かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

   かつ "tengine_heartbeat_watchd"の設定ファイル"config/heartbeat_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する
   #2プロセス起動します
   かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する

   かつ "tengine_atd"の設定ファイル"config/atd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する
   #2プロセス起動します
   かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する

   かつ "tengine_resouce_watchd"の設定ファイル"config/resouce_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_resource_watchd"の起動行うために"tengine_resource_watchd -f config/resource_watchd.yml.erb"というコマンドを実行する

   かつ "テンプレートジョブ一覧画面"を表示する
   ならば "テンプレートジョブ一覧画面"を表示していること
   かつ 以下の行が表示されていること
   |ジョブネット名|説明  |操作     |
   |jobnet1001        |jobnet1001|閲覧 実行|
    

   もし "テンプレートジョブ一覧画面"を表示する
   かつ "jobnet1001"の"実行"リンクをクリックする
   ならば "ジョブネット実行設定画面"を表示していること

   もし "ジョブネット実行設定画面"を表示する
   かつ "事前実行コマンド"に"export SLEEP=60"と入力する
   # SLEEPの時間は、MongoDBがフェールオーバする時間を考慮して長めにしていますが、実際にテストはしていないため、この長さでも短い可能性があります
   # もし、connect failureとエラーが出力された場合は、SLEEP時間を長く設定して下さい。おおよそ、この時間で問題ないという値がわかれば、このfeatureを編集してSLEEPの値を変更し、このコメントを削除して下さい。
   ならば ジョブはまだ実行されていないこと

   # MongoDBのプライマリーのプロセスを停止/停止確認をする
   もし mongod_pをダウンさせるために"ssh root@#{mongod_p_ip} command \"ps -eo pid,command|grep mongod|grep -v grep| cut -d ' ' -f2|xargs kill -9\""コマンドを実行する
   かつ 10秒間待機する
   かつ mongod_pがダウンしているか確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   ならば mongod_pがダウンしていること

   # ジョブを実行する
   もし "実行"ボタンをクリックする
   ならば "ジョブネット監視画面"を表示していること
   かつ 以下の行が表示されていること
   |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
   |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   # ジョブのスクリプト実行中に強制停止ボタンを押下
   もし "強制停止"ボタンをクリックする
   かつ 10秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |強制停止中    |          |表示 再実行  |
   # ジョブが「エラー終了(タイムアウト強制停止済)」となることを確認する
   かつ 20秒間待機する
   ならば ジョブネットのステータスが「エラー終了(強制停止済)」と表示されていること

   # フェイルオーバできることの確認
   もし  mongod_s1,mongod_s2のいずれかがPRIMARYになっていることを確認するために"ssh root@#{mongod_s1_ip} command \"mongo status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"(not reachable/healthy)"と表示されていること
   ならば mongod_s1,mongod_s2のいずれかの"stateStr"が"PRIMARY"と表示されていること

   # 停止したDBプロセスをフェイルバックする
   もし mongod_pを起動しなおすために"ssh root@#{mongod_p_ip} command \"mongod --replSet tengine_rs --port 27017 --dbpath /home/tengine/mongo_data/replSet/data --logpath /home/tengine/mongo_data/replSet/tengine.log --fork --logappend --rest --journal\""コマンドを実行する
   かつ mongod_pが起動していることを確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   かつ mongod_pがSECONDARYになっていることを確認するために"ssh root@#{mongod_p_ip} command \"mongo features/step_definitions/mongodb/status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"SECONDARY"と表示されていること



  シナリオ: ジョブ再実行前にMongoDBのプライマリーのプロセスがダウンした際にフェールオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする
   前提 仮想サーバ"test_server1"のジョブ実行ユーザのホームディレクトリにファイル:"tengine_job_test.log"が存在しないこと
   もし "tengined"の設定ファイル"config/tengined.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
   かつ "Tengineコアプロセス"の標準出力からPIDを確認する
   かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する
   #2プロセス起動します
   かつ "Tengineコアプロセス"の起動を行うために"tengined -T ./usecases/job/dsl/1001_one_job_in_jobnet.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
   かつ "Tengineコアプロセス"の標準出力からPIDを確認する
   かつ "Tengineコアプロセス"の状態が"稼働中"であることを確認する

   かつ "tengine_heartbeat_watchd"の設定ファイル"config/heartbeat_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する
   #2プロセス起動します
   かつ "tengine_heartbeat_watchd"の起動行うために"tengine_atd -f config/heartbeat_watchd.yml.erb"というコマンドを実行する

   かつ "tengine_atd"の設定ファイル"config/atd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する
   #2プロセス起動します
   かつ "tengine_atd"の起動行うために"tengine_atd -f config/atd.yml.erb"というコマンドを実行する

   かつ "tengine_resouce_watchd"の設定ファイル"config/resouce_watchd.yml.erb"の"max_retries_on_connection_failure"の値が"100"である
   かつ "tengine_resource_watchd"の起動行うために"tengine_resource_watchd -f config/resource_watchd.yml.erb"というコマンドを実行する

   かつ "テンプレートジョブ一覧画面"を表示する
   ならば "テンプレートジョブ一覧画面"を表示していること
   かつ 以下の行が表示されていること
   |ジョブネット名|説明  |操作     |
   |jobnet1001        |jobnet1001|閲覧 実行|

   もし "テンプレートジョブ一覧画面"を表示する
   かつ "jobnet1001"の"実行"リンクをクリックする
   ならば "ジョブネット実行設定画面"を表示していること

   もし "ジョブネット実行設定画面"を表示する
   かつ "実行"ボタンをクリックする
   ならば "ジョブネット監視画面"を表示していること
   かつ 以下の行が表示されていること
   |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
   |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   もし 10秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |正常終了    |          |表示 再実行  |

   もし "実行中のジョブ一覧画面"を表示する
   かつ 実行したジョブの行の"再実行"リンクをクリックする
   ならば "ジョブネット再実行設定画面"が表示されていること

   もし "ジョブネット再実行設定画面"を表示する
   かつ "事前実行コマンド"に"export SLEEP=60"と入力する
   # SLEEPの時間は、MongoDBがフェールオーバする時間を考慮して長めにしていますが、実際にテストはしていないため、この長さでも短い可能性があります
   # もし、connect failureとエラーが出力された場合は、SLEEP時間を長く設定して下さい。おおよそ、この時間で問題ないという値がわかれば、このfeatureを編集してSLEEPの値を変更し、このコメントを削除して下さい。
   ならば ジョブはまだ実行されていないこと

   # MongoDBのプライマリーのプロセスを停止/停止確認をする
   もし mongod_pをダウンさせるために"ssh root@#{mongod_p_ip} command \"ps -eo pid,command|grep mongod|grep -v grep| cut -d ' ' -f2|xargs kill -9\""コマンドを実行する
   かつ 10秒間待機する
   かつ mongod_pがダウンしているか確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   ならば mongod_pがダウンしていること

   # ジョブを実行する
   もし "実行"ボタンをクリックする
   ならば "ジョブネット監視画面"を表示していること
   かつ 以下の行が表示されていること
   |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
   |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |実行中    |            |表示 強制停止|

   # ジョブが正常終了することを確認する
   もし 50秒間待機する
   ならば 以下の行が表示されていること
    |ID|ジョブ名  |説明     |実行スクリプト                 |接続サーバ名|認証情報名         |開始日時            |終了日時|ステータス |次のジョブ   |操作        |
    |  |job1     |job1    |$HOME/tengine_job_test.sh 0 job1|test_server1|test_credential1|2011/11/25 14:43:22|       |正常終了    |          |表示 再実行  |

   # フェイルオーバできることの確認
   もし  mongod_s1,mongod_s2のいずれかがPRIMARYになっていることを確認するために"ssh root@#{mongod_s1_ip} command \"mongo status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"(not reachable/healthy)"と表示されていること
   ならば mongod_s1,mongod_s2のいずれかの"stateStr"が"PRIMARY"と表示されていること

   # 停止したDBプロセスをフェイルバックする
   もし mongod_pを起動しなおすために"ssh root@#{mongod_p_ip} command \"mongod --replSet tengine_rs --port 27017 --dbpath /home/tengine/mongo_data/replSet/data --logpath /home/tengine/mongo_data/replSet/tengine.log --fork --logappend --rest --journal\""コマンドを実行する
   かつ mongod_pが起動していることを確認するために"ssh root@#{mongod_p_ip} command \"ps aux|grep mongod|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   かつ mongod_pがSECONDARYになっていることを確認するために"ssh root@#{mongod_p_ip} command \"mongo features/step_definitions/mongodb/status.js"コマンドを実行する
   ならば mongod_pの"stateStr"が"SECONDARY"と表示されていること

