#language:ja
機能: アプリケーション運用者がDBがフェイルオーバーした後にフェイルバックする

  DBがダウンした際に、
  アプリケーション運用者
  は、フェイルオーバーしていることを確認した後、フェイルバックを行いたい

  背景:DBプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする
    前提 "DBサーバ1"上で"DBプロセス1"が起動している
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

    かつ "物理サーバ1"上に"Coreサーバ1", "MQサーバ2", "Frontendサーバ2"が動作していること
    かつ "物理サーバ2"上に"MQサーバ2", "DBサーバ2"が動作していること
    かつ "物理サーバ3"上に"Coreサーバ2, "DBサーバ3", "Frontendサーバ1" が動作していること

  @08_07_03_01
  #start.jobnet.job.tengine
  シナリオ: [異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/start.jobnet.job.tengineイベント処理中にCoreサーバがダウンする.feature
    #(1-1) 
    #[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

    # 以下フェイルバックの確認
    もし 落ちたサーバを確認し、落ちた物理サーバを"down_physical_server"と呼ぶ
    かつ down_physical_serverを起動する
    ならば down_physical_severが起動すること

    もし down_physical_severにログインし、物理サーバ上で動作していた仮想サーバを"virsh start #{仮想サーバ名}"コマンドで起動する
    ならば downサーバ上に仮想サーバが起動していることを"virsh list"コマンドを用いて確認できること

    もし down_physical_sever上のCoreサーバにログインする
    ならば  down_physical_sever上のCoreサーバで動作していた"Tengineコアプロセス","tengine_resouce_watchd","heartbeat_watchd1","atd1"のPIDファイルを削除する
    かつ down_physical_sever上で動作していた"Tengineコアプロセス"のstatusファイルを削除する

    もし "down_physical_sever"上で"Tengineコアプロセス"の起動を行うために"tengined -T ../tengine_job/examples/0004_retry_one_layer.rb -f ./features/config/tengined.yml.erb "というコマンドを実行する
    ならば "Tengineコアプロセス"の状態が"稼働中"であることを確認できること

    もし "down_physical_sever"上で"tengine_atdプロセス"の起動を行うために"tengine_atd -f ./features/config/atd.yml.erb "というコマンドを実行する
    ならば "tengine_atd"の状態が"稼働中"であることを確認できること

    もし "down_physical_sever"上で"tengine_heartbeatプロセス"の起動を行うために"tengine_heartbeat -f ./features/config/resouce_watchd.yml.erb "というコマンドを実行する
    ならば "tengine_resouce_watchd"の状態が"稼働中"であることを確認できること

    もし "down_physical_sever"上で"tengine_heartbeatプロセス"の起動を行うために"tengine_heartbeat -f ./features/config/heartbeat_watchd.yml.erb "というコマンドを実行する
    ならば "tengine_heartbeat_watchd"の状態が"稼働中"であることを確認できること

    もし "テンプレートジョブ一覧画面"を表示する
    ならば "テンプレートジョブ一覧画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブネット名|説明  |操作     |
    |jn0004        |jn0004|閲覧 実行|

    もし "テンプレートジョブ一覧画面"を表示する
    かつ "jn0004"の"実行"リンクをクリックする
    ならば "ジョブネット実行設定画面"を表示していること

    もし "実行"ボタンをクリックする
    ならば "ジョブネット監視画面"を表示していること
    かつ 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |実行中    |表示 強制停止  |
    |j2        |初期化済  |表示 再実行  |
    |j3        |初期化済  |表示 再実行  |
    |j4        |初期化済  |表示 再実行  |
    |finally   |初期化済  |表示 再実行  |
    |  jn0004_f|初期化済  |表示 再実行  |

    もし 20秒間待機する
    ならば 以下の行が表示されていること
    |ジョブ名   |ステータス|操作         |
    |j1        |正常終了    |表示 再実行  |
    |j2        |正常終了  |表示 再実行  |
    |j3        |正常終了  |表示 再実行  |
    |j4        |正常終了  |表示 再実行  |
    |finally   |正常終了  |表示 再実行  |
    |  jn0004_f|正常終了  |表示 再実行  |

    もし "実行ジョブ一覧画面"を表示する
    ならば 以下の行が表示されていること
    |ジョブネット名|ステータス|操作       |
    |jn0004      |正常終了  |監視 ステータス変更 再実行|
    
  @08_07_04_01
  #start.job.job.tengine
  シナリオ: [異常系]start.job.job.tengineのイベント処理中に、スクリプトのPIDが帰ってきてからジョブストアのジョブネットの状態を更新する間に、物理サーバがダウンする_finished.process.job.tengineがイベント処理失敗イベントの前に処理される

    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/start.job.job.tengineイベント処理中にCoreサーバがダウンする.feature
    #(3-1)
    #[異常系]start.job.job.tengineのイベント処理中に、スクリプトのPIDが帰ってきてからジョブストアのジョブネットの状態を更新する間に、Coreサーバがダウンする_finished.process.job.tengineがイベント処理失敗イベントの前に処理される

    # 以下フェイルバックの確認
    #「[異常系]start.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照
    
  @08_07_05_01
  #finished.process.job.tengine
  シナリオ: [異常系][異常系]finished.process.core.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする_スクリプトが正常終了していた
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/finished.process.job.tengineイベント処理中にCoreサーバがダウンする.feature
    ##(1-1)
    #[異常系][異常系]finished.process.core.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする_スクリプトが正常終了していた

    # 以下フェイルバックの確認
    #「[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照

  @08_07_06_01
  #success.job.job.tengine
  シナリオ: [異常系][異常系]success.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/success.job.job.tengineイベント処理中にCoreサーバがダウンする.feature
    ##(1-1)
    #[異常系]success.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

    # 以下フェイルバックの確認
    #「[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照

  @08_07_07_01
  #success.jobnet.job.tengine
  シナリオ: [異常系]success.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/success.jobnet.job.tengineイベント処理中にCoreサーバがダウンする.feature
    ##(1-1)
    #[異常系]success.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

    # 以下フェイルバックの確認
    #「[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照

  @08_07_08_01
  #error.job.job.tengine
  シナリオ: [異常系]error.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/error.job.job.tengineイベント処理中にCoreサーバがダウンする.feature
    #(1-1)
    #[異常系]error.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

    # 以下フェイルバックの確認
    #「[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照

  @08_07_09_01
  #error.jobnet.job.tengine
  シナリオ: [異常系]error.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/error.jobnet.job.tengineイベント処理中にCoreサーバがダウンする.feature
    #(1-1)
    #[異常系]error.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

    # 以下フェイルバックの確認
    #「[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照

  @08_07_10_01
  #stop.jobnet.job.tengine
  シナリオ: [異常系]stop.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/stop.jobnet.job.tengineイベント処理中にCoreサーバがダウンする.feature
    #(1-1)
    #[異常系]stop.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

    # 以下フェイルバックの確認
    #「[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照

  @08_07_11_01
  #stop.job.job.tengine
  シナリオ: [異常系]stop.job.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする
    
    以下のシナリオのフェイルバックの前まで行う(仮想サーバでなく、仮想サーバが動作している物理サーバをシャットダウンする)
    #tengine_console/features/usecases/job/アプリケーション運用者がジョブを実行中にCoreサーバがダウンしたことを確認してフェイルバックする/stop.job.job.tengineイベント処理中にCoreサーバがダウンする.feature
    #(1-1)
    #[異常系]stop.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、Coreサーバがダウンする

    # 以下フェイルバックの確認
    #「[異常系]start.jobnet.job.tengineのイベント処理中に、ジョブストアのジョブネットの状態を更新した後に、物理サーバがダウンする」のフェイルバックの確認を参照