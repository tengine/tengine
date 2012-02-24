#language:ja
機能: アプリケーション運用者がDBがフェイルオーバーした後にフェイルバックする

  DBがダウンした際に、
  アプリケーション運用者
  は、フェイルオーバーしていることを確認した後、フェイルバックを行いたい

  背景:DBプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする
    前提 "DBサーバ1"上で"DBプロセス1"が起動している

    かつ "キュープロセス"が起動している
    かつ "Frondendサーバ1"上で"Tengineコンソールプロセス"が起動している
    かつ "Frondendサーバ2"上で"Tengineコンソールプロセス"が起動している
    かつ ジョブ実行環境の仮想サーバがインスタンス識別子:"test_server1"で登録されていること
    かつ 認証情報が名称:"test_credential1"で登録されている
    かつ Replica Setsを設定したMongoDBが3台のサーバで動作していること
    かつ Replica SetsのPRIMARYノードで動作しているmongodプロセスをmongod_pと呼ぶ
    かつ Replica SetsのSECONDARYノードで動作しているmongodプロセスをmongod_s1, mongod_s2と呼ぶ
    かつ mongod_pが動作しているサーバのIPをmongod_p_ipと呼ぶ
    かつ mongod_pが動作しているサーバを"DBサーバ1"と呼ぶ
    かつ mongod_s1が動作しているサーバのIPをmongod_s1_ipと呼ぶ
    かつ mongod_s1が動作しているサーバを"DBサーバ2"と呼ぶ
    かつ mongod_s2が動作しているサーバのIPをmongod_s2_ipと呼ぶ
    かつ mongod_s2が動作しているサーバを"DBサーバ3"と呼ぶ
# $ bundle exec irb -rmongoid
# > Mongoid.load!("path/to/your/mongoid.yml")
# > db = Mongoid.config.database
# > db.connection.primary

    かつ "MQサーバ1"上に"Heartbeat,Pacemakerから起動された"MQプロセス1"が起動している
    かつ "MQプロセス1" の書き込み先にDRBDを利用していること
    かつ "MQサーバ2"上に"Heartbeat,Pacemakerから起動された"MQプロセス2"が起動していない

    かつ "Coreサーバ1"上に"resource_watchd1","heartbeat_watchd1","atd1"が動作していること
    かつ "Coreサーバ2"上に"resource_watchd2","heartbeat_watchd2","atd2"が動作していること
    かつ "Coreサーバ1"のIPを"core_server1_ip"と呼ぶ
    かつ "Coreサーバ2"のIPを"core_server2_ip"と呼ぶ


# start.execution.job.tengine(1) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# start.execution.job.tengine(2) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、start.jobnet.job.tengineを発火した後に、Coreサーバがダウンする

# start.execution.job.tengine(3) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、スケジュールストアにタイムアウト警告のスケジュールを登録した後に、Coreサーバがダウンする

# start.execution.job.tengine(4) #
  シナリオ: [異常系]start.execution.job.tengineのイベント処理中に、スケジュールストアにタイムアウト強制停止のスケジュールを登録した後に、Coreサーバがダウンする


# start.jobnet.job.tengine(1) #
  シナリオ: [異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# start.jobnet.job.tengine(2) #
  シナリオ: [異常系]start.jobnet.job.tengineのイベント処理中に、start.jobnet.job.tengineやstart.job.job.tengineをいくつか発火した後に、Coreサーバがダウンする

# start.jobnet.job.tengine(3) #
  シナリオ: [異常系]start.jobnet.job.tengineのイベント処理中に、start.jobnet.job.tengineやstart.job.job.tengineを全て発火した後に、Coreサーバがダウンする


# start.job.job.tengine(1) #
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# start.job.job.tengine(2) #
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、sshを実行してからスクリプトのPIDが返ってくる間に、Coreサーバがダウンする

# start.job.job.tengine(3) #
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、スクリプトのPIDが帰ってきてからジョブストアのジョブネットの状態を更新する間に、Coreサーバがダウンする

# start.job.job.tengine(4) #
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、スクリプトのPIDが帰ってきてジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする


# finished.process.core.tengine(1) #
  シナリオ: [異常系]finished.process.core.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# finished.process.core.tengine(2) #
  シナリオ: [異常系]finished.process.core.tengineのイベント処理中に、success.job.job.tengineを発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]finished.process.core.tengineのイベント処理中に、error.job.job.tengineを発火した後に、Coreサーバがダウンする


# success.job.job.tengine(1) #
  シナリオ: [異常系]success.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# success.job.job.tengine(2) #
  シナリオ: [異常系]success.job.job.tengineのイベント処理中に、start.jobnet.job.tengineやstart.job.job.tengineをいくつか発火した後に、Coreサーバがダウンする

# success.job.job.tengine(3) #
  シナリオ: [異常系]success.job.job.tengineのイベント処理中に、start.jobnet.job.tengineやstart.job.job.tengineを全て発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]success.job.job.tengineのイベント処理中に、success.jobnet.job.tengineを発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]success.job.job.tengineのイベント処理中に、error.jobnet.job.tengineを発火した後に、Coreサーバがダウンする


# success.jobnet.job.tengine(1) #
  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# success.jobnet.job.tengine(2) #
  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、start.jobnet.job.tengineやstart.job.job.tengineをいくつか発火した後に、Coreサーバがダウンする

# success.jobnet.job.tengine(3) #
  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、start.jobnet.job.tengineやstart.job.job.tengineを全て発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、success.jobnet.job.tengineを発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、error.jobnet.job.tengineを発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、success.execution.job.tengineを発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、error.execution.job.tengineを発火した後に、Coreサーバがダウンする


# success.execution.job.tengine(1) #
  シナリオ: [異常系]success.execution.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# success.execution.job.tengine(2) #
  シナリオ: [異常系]success.execution.job.tengineのイベント処理中に、スケジュールストアに登録されているタイムアウト警告のスケジュールを無効化した後に、Coreサーバがダウンする

# success.execution.job.tengine(3) #
  シナリオ: [異常系]success.execution.job.tengineのイベント処理中に、スケジュールストアに登録されているタイムアウト強制停止のスケジュールを無効化した後に、Coreサーバがダウンする


# error.job.job.tengine(1) #
  シナリオ: [異常系]error.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# error.job.job.tengine(2) #
  シナリオ: [異常系]error.job.job.tengineのイベント処理中に、error.jobnet.job.tengineを発火した後に、Coreサーバがダウンする


# error.jobnet.job.tengine(1) #
  シナリオ: [異常系]error.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# error.jobnet.job.tengine(2) #
  シナリオ: [異常系]error.jobnet.job.tengineのイベント処理中に、error.jobnet.job.tengineを発火した後に、Coreサーバがダウンする

  シナリオ: [異常系]error.jobnet.job.tengineのイベント処理中に、error.execution.job.tengineを発火した後に、Coreサーバがダウンする


# error.execution.job.tengine(1) #
  シナリオ: [異常系]error.execution.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# error.execution.job.tengine(2) #
  シナリオ: [異常系]error.execution.job.tengineのイベント処理中に、スケジュールストアに登録されているタイムアウト警告のスケジュールを無効化した後に、Coreサーバがダウンする

# error.execution.job.tengine(3) #
  シナリオ: [異常系]error.execution.job.tengineのイベント処理中に、スケジュールストアに登録されているタイムアウト強制停止のスケジュールを無効化した後に、Coreサーバがダウンする


# stop.jobnet.job.tengine(1) #
  シナリオ: [異常系]stop.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# stop.jobnet.job.tengine(2) #
  シナリオ: [異常系]stop.jobnet.job.tengineのイベント処理中に、stop.jobnet.job.tengineやstop.job.job.tengineをいくつか発火した後に、Coreサーバがダウンする

# stop.jobnet.job.tengine(2) #
  シナリオ: [異常系]stop.jobnet.job.tengineのイベント処理中に、stop.jobnet.job.tengineやstop.job.job.tengineを全て発火した後に、Coreサーバがダウンする


# stop.job.job.tengine(1) #
  シナリオ: [異常系]stop.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

# stop.job.job.tengine(2) #
  シナリオ: [異常系]stop.job.job.tengineのイベント処理中に、sshでスクリプトを停止するコマンドを実行した後に、Coreサーバがダウンする


# expired.job.heartbeat.tengine(1) #
  シナリオ: [異常系]expired.job.heartbeat.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする



