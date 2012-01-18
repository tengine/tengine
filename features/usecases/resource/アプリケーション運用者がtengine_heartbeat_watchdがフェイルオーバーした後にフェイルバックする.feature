#language:ja
機能: アプリケーション運用者がtengine_heartbeat_watchdがフェイルオーバーした後にフェイルバックする

  tengine_heartbeat_watchdがダウンした際に、
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
    かつ heartbeat_watchd.yml.erbに以下の設定がされてる
    process:
      daemon:  true
      pid_dir: "/tmp/tengine_test/pids"
    かつ /tmp/tengine_test/pidsディレクトリが存在する
    # mkdir -p /tmp/tengine_test/pids
    かつ "tengine_heartbeat_watchdプロセス"が2台のサーバで起動している
    かつ サーバ1で起動しているtengine_heartbeat_watchdプロセスを"heartbeat_watchd1"と呼ぶ
    かつ サーバ2で起動しているtengine_heartbeat_watchdプロセスを"heartbeat_watchd2"と呼ぶ
    かつ heartbeat_watchd1が動作しているサーバのIPを"heartbeat_watchd1_ip"と呼ぶ
    かつ heartbeat_watchd2が動作しているサーバのIPを"heartbeat_watchd2_ip"と呼ぶ
    かつ heartbeat_watchd1のPIDを"heartbeat_watchd1_pid"と呼ぶ
    かつ heartbeat_watchd2のPIDを"heartbeat_watchd2_pid"と呼ぶ


  @success
  @1000
  シナリオ: [異常系]ジョブのスクリプト実行中にtengine_heartbeat_watchdのプロセスがダウンした際にフェイルオーバーし、その後アプリケーション運用者がDBプロセスをフェールバックする

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

    もし "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "仮想サーバ名"に"run_virtual_servers"と入力する
    かつ "物理サーバ名"に"physical_server_name_01"を選択する
    かつ "仮想サーバイメージ名"に"virtual_server_image_uuid_01"を選択する
    かつ "仮想サーバタイプ"に"virtual_server_spec_uuid_01"を選択する
    かつ "起動サーバ数"に1を選択する
    かつ "説明"に"仮想サーバを1台起動テストの説明"と入力する
    かつ "起動"ボタンをクリックする
    ならば "仮想サーバ起動結果"画面が表示されること
    かつ  "仮想サーバ起動結果"画面に以下の表示があること
    virtual_server_uuid_01

    もし "閉じる"ボタンを押下する
    ならば "仮想サーバ一覧"画面が表示されていること

    もし "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがstartingになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_1_virtual_servers001|virtual_server_uuid_01|仮想サーバを1台起動テストの説明|private_ip_address: 192.168.1.1|starting|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

   もし heartbeat_watchd1をダウンさせるために"ssh root@#{heartbeat_watchd1_ip} command \"kill -9 #{heartbeat_watchd1_pid}\""コマンドを実行する
   かつ 10秒間待機する
   かつ heartbeat_watchd1がダウンしているか確認するために"ssh root@#{heartbeat_watchd1_ip} command \"ps aux|grep tengine_heartbeat_watchd|grep -v grep\""コマンドを実行する
   ならば heartbeat_watchd1がダウンしていること

   もし 120秒間待機する
   かつ "仮想サーバ一覧"画面を表示する
    ならば "仮想サーバ一覧"画面に以下の行が表示されていること
    # 仮想サーバ名、説明はつけていないので、空の状態です。
    # ステータスがrunningになるまで時間がかかります(環境によって異なります)
    |物理サーバ名             |仮想サーバ名|プロバイダによるID  |説明|IPアドレス|ステータス|仮想サーバイメージ名|仮想サーバタイプ|
    |physical_server_name_01|run_1_virtual_servers001|virtual_server_uuid_01|仮想サーバを1台起動テストの説明|private_ip_address: 192.168.1.1|running|virtual_server_image_uuid_01|virtual_server_spec_uuid_01|

   もし tengine_heartbeat_watchdプロセスを起動しなおすために"ssh root@#{heartbeat_watchd1_ip} command \"rm -rf /tmp/tengine_test/pids/tengine_heartbeat_watchd0.pid && cd #{tengine_heartbeat_watchdのデプロイ先のパス} && bundle exec tengine_heartbeat_watchd -k start -f config/heartbeat_watchd.yml.erb\""コマンドを実行する
   かつ tengine_heartbeat_watchdプロセスが起動していることを確認するために"ssh root@#{heartbeat_watchd1_ip} command \"ps aux|grep tengine_heartbeat_watchd|grep -v grep\""コマンドを実行する
   かつ 20秒間待機する
   ならば tengine_heartbeat_watchdプロセスが起動していること

